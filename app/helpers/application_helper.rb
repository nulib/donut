module ApplicationHelper
  def error_collector(error_hash)
    return 'No errors' if error_hash.empty?
    error_hash.collect do |field, errors|
      Array(errors).collect { |error| "#{field}: #{error} " }
    end.flatten.join('<br/>')
  end

  def status_context(status)
    case status
    when 'complete'    then 'success'
    when 'error'       then 'danger'
    when 'initialized' then 'info'
    when 'processing'  then 'active'
    else ''
    end
  end

  def status_label(status)
    status_span_generator status
  end

  def accession_number_linker(accession_number)
    return 'No accession number' if accession_number.blank?
    link_to(accession_number, batch_item_path(accession_number: accession_number))
  end

  def item_exists?(item_id)
    ::SolrDocument.find(item_id).present?
  rescue
    false
  end

  def item_linker(item)
    return nil if item.created_item.blank?
    if item_exists?(item.created_item)
      type = item.attribute_hash[:type].underscore.pluralize
      link_to(item.created_item, "/concern/#{type}/#{item.created_item}")
    else
      content_tag(:strike, item.created_item.to_s)
    end
  end

  def public_iiif_manifest_linker(id)
    link_to('Public IIIF Manifest', IiifManifestService.manifest_url(id).to_s, class: 'btn btn-default')
  end

  ##
  # Render the thumbnail, if available, for a document and
  # link it to the document record.
  #
  # @param [SolrDocument] document
  # @param [Hash] image_options to pass to the image tag
  # @param [Hash] url_options to pass to #link_to_document
  # @return [String]
  def render_thumbnail(document, _image_options = {}, _url_options = {})
    return default_image if document.nil?
    object = ActiveFedora::Base.find(document.id)
    if object.is_a?(::AdminSet)
      default_image
    elsif object.is_a?(::Collection)
      render_thumbnail(object.send(:thumbnail))
    elsif object.is_a?(::Image)
      render_thumbnail(object.send(:thumbnail))
    else
      image_tag("#{IiifDerivativeService.resolve(object.id)}/full/200,/0/default.jpg")
    end
  end

  private

    def default_image
      image_tag(ActionController::Base.helpers.image_path('default.png'), size: '200')
    end

    def status_span_generator(status)
      fa_class = case status
                 when 'complete' then 'fa fa-check-circle'
                 when 'empty' then 'fa fa-minus-circle'
                 when 'error' then 'fa fa-exclamation-triangle'
                 when 'initialized' then 'fa fa-info'
                 when 'processing' then 'fa fa-refresh fa-sync'
                 when 'skipped' then 'fa fa-forward'
                 end
      content_tag(:span, class: fa_class) do
        concat ' ' # en space
        concat content_tag(:a, status.titleize)
      end
    end
  # rubocop:enable Metrics/CyclomaticComplexity
end
