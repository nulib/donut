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

  def item_linker(item)
    return nil if item.created_item.blank?
    type = item.attribute_hash[:type].underscore.pluralize
    link_to(item.created_item, "/concern/#{type}/#{item.created_item}")
  end

  private

    # rubocop:disable Metrics/CyclomaticComplexity
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
