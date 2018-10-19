class IiifManifestService
  class << self
    def manifest_url(work_id)
      Pathname.new(Settings.metadata.endpoint).join(s3_key_for(work_id))
    end

    def remove_manifest(work_id)
      obj = Aws::S3::Object.new(Settings.aws.buckets.manifests, s3_key_for(work_id))
      obj.delete
    end

    def write_manifest(work_id)
      presenter = S3IiifManifestPresenter.new(SolrDocument.find(work_id), S3ManifestAbility.new)
      manifest_json = JSON.pretty_generate(::IIIFManifest::ManifestFactory.new(presenter).to_h)
      destination = Aws::S3::Object.new(Settings.aws.buckets.manifests, s3_key_for(work_id))
      destination.put(body: manifest_json, acl: 'public-read')
    end

    private

      def s3_key_for(work_id)
        File.join('public', Pathname.new(derivative_path_for(work_id)).relative_path_from(Hyrax.config.derivatives_path).to_s)
      end

      def derivative_path_for(work_id)
        Hyrax::DerivativePath.derivative_path_for_reference(work_id, 'manifest').sub!(/manifest$/, 'json')
      end
  end
end
