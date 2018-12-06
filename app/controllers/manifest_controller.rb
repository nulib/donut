class ManifestController < ApplicationController
  prepend_before_action { params[:id].delete!('/') }

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
