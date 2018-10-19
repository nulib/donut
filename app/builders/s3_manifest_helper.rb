# used in order to override build_rendering
# from Hyrax: https://github.com/samvera/hyrax/blob/master/app/builders/hyrax/manifest_helper.rb
# to change the @id/url to download the renderings from s3 instead of Donut
# for use in our public iiif manifests stored on s3
class S3ManifestHelper
  # Build a rendering hash
  #
  # @return [Hash] rendering
  def build_rendering(file_set_id)
    file_set_document = query_for_rendering(file_set_id)
    original_file = ::FileSet.find(file_set_id).original_file
    url = IiifDerivativeService.resolve(original_file.id).join('full/full/0/default.jpg')
    label = file_set_document.label.present? ? ": #{file_set_document.label}" : ''
    mime = file_set_document.mime_type.present? ? file_set_document.mime_type : I18n.t('hyrax.manifest.unknown_mime_text')
    {
      '@id' => url,
      'format' => mime,
      'label' => I18n.t('hyrax.manifest.download_text') + label
    }
  end

  # Query for the properties to create a rendering
  #
  # @return [SolrDocument] query result
  def query_for_rendering(file_set_id)
    ::SolrDocument.find(file_set_id)
  end
end
