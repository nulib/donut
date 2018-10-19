require 'iiif_manifest'

module Hyrax
  # This gets mixed into FileSetPresenter in order to create
  # a canvas on a IIIF manifest
  module DisplaysImage
    extend ActiveSupport::Concern

    # Creates a display image only where FileSet is an image.
    #
    # @return [IIIFManifest::DisplayImage] the display image required by the manifest builder.
    def display_image
      return nil unless ::FileSet.exists?(id) && solr_document.image? && current_ability.can?(:read, id)
      # @todo this is slow, find a better way (perhaps index iiif url):
      original_file = ::FileSet.find(id).original_file

      url = Hyrax.config.iiif_image_url_builder.call(
        original_file.id,
        'http://thisisnotused',
        Hyrax.config.iiif_image_size_default
      )
      # @see https://github.com/samvera-labs/iiif_manifest
      IIIFManifest::DisplayImage.new(url,
                                     width: 640,
                                     height: 480,
                                     iiif_endpoint: iiif_endpoint(original_file.id))
    end

    private

      def iiif_endpoint(file_id)
        return unless Hyrax.config.iiif_image_server?
        IIIFManifest::IIIFEndpoint.new(
          Hyrax.config.iiif_info_url_builder.call(file_id, 'http://thisisnotused'),
          profile: Hyrax.config.iiif_image_compliance_level_uri
        )
      end
  end
end
