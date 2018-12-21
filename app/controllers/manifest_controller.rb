class ManifestController < ApplicationController
  prepend_before_action { params[:id].delete!('/') }

  def public_manifest
    headers['Access-Control-Allow-Origin'] = '*'
    respond_to do |wants|
      wants.json { render json: manifest_builder }
      wants.html { render json: manifest_builder }
    end
  end

  private

    def write_if_newer(doc, cached)
      return if cached.exists? && cached.last_modified >= Time.zone.parse(doc['system_modified_dtsi'])
      Rails.logger.info("Writing manifest for #{params[:id]}")
      IiifManifestService.write_manifest(params[:id])
    end

    def manifest_builder
      doc = ::SolrDocument.find(params[:id])
      return {} if doc['visibility_ssi'] == 'restricted'
      cached = IiifManifestService.s3_object_for(params[:id])
      write_if_newer(doc, cached)
      JSON.parse(cached.get.body.read)
    end
end
