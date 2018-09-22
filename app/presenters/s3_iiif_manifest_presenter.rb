class S3IiifManifestPresenter < Hyrax::ImagePresenter
  def manifest_helper
    @manifest_helper ||= S3ManifestHelper.new
  end

  # IIIF manifest_url for inclusion in the manifest
  # called by the iiif_manifest gem
  def manifest_url
    IiifManifestService.manifest_url(id)
  end

  # IIIF metadata for inclusion in the manifest
  #  Called by the `iiif_manifest` gem to add metadata
  #
  # @return [Array] array of metadata hashes
  def manifest_metadata
    metadata_fields = [:title, :accession_number, :date_created, :abstract, :creator_label, :subject_topical_label, :rights_statement]
    metadata = []
    metadata_fields.each do |field|
      values = Array.wrap(send(field))
      next if values.blank?
      metadata << {
        'label' => I18n.t("simple_form.labels.defaults.#{field}"),
        'value' => values
      }
    end
    metadata
  end
end
