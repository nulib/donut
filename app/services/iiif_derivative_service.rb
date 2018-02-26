class IiifDerivativeService
  class << self
    def s3?
      return !(Settings&.aws&.buckets&.pyramids.nil?)
    end

    def derivative_path_for(file_id)
      Hyrax::DerivativePath.derivative_path_for_reference(file_part_of(file_id), 'pyramid').sub!(/pyramid$/,'tif')
    end

    def s3_key_for(file_id)
      Pathname.new(derivative_path_for(file_id)).relative_path_from(Hyrax.config.derivatives_path).to_s
    end

    def resolve(id, extra_path: nil)
      iiif_id = file_part_of(id).split(//).in_groups_of(2).collect(&:join).join('%2F')
      Pathname.new(Settings.iiif.endpoint).join(iiif_id, extra_path.to_s)
    end

    private

      def file_part_of(id)
        id.split(%r{/files/}).last
      end
  end
end
