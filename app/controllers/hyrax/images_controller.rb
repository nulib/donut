# Generated via
#  `rails generate hyrax:work Image`

module Hyrax
  class ImagesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Image

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::ImagePresenter

    def public_manifest
      headers['Access-Control-Allow-Origin'] = '*'
      respond_to do |wants|
        wants.json { render json: manifest_builder.to_h }
        wants.html { render json: manifest_builder.to_h }
      end
    end

    private

      def manifest_builder
        doc = ::SolrDocument.find(params[:id])
        return {} if doc['visibility_ssi'] == 'restricted'
        presenter = S3IiifManifestPresenter.new(doc, S3ManifestAbility.new)
        ::IIIFManifest::ManifestFactory.new(presenter)
      end
  end
end
