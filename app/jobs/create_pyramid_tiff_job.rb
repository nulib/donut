class CreatePyramidTiffJob < ApplicationJob
  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the Hyrax.config.working_path

  MAX_PIXELS = 0x3FFF**2

  def perform(file_set, file_id, filepath = nil)
    filename = vips_file(file_set, file_id, filepath)
    image = Vips::Image.new_from_file(filename)
    scale_factor = MAX_PIXELS / (image.width * image.height).to_f
    image = image.resize(scale_factor) if scale_factor < 1.0
    write_tiff(image, file_set.id)
  end

  private

    def vips_file(file_set, file_id, filepath)
      service = Hyrax::DerivativeService.for(file_set)
      filename = service.prepare_file(Hyrax::WorkingDirectory.find_or_retrieve(file_id, file_set.id, filepath))
      basename = File.basename(filename, File.extname(filename))
      (File.join(File.dirname(filename), basename) + '.v').tap do |vips_filename|
        unless File.exist?(vips_filename)
          Vips::Image.new_from_file(filename).vipssave(vips_filename, strip: true)
        end
      end
    end

    def write_tiff(image, file_id)
      output_params = { compression: 'jpeg', Q: 75, tile: true, tile_height: 256, tile_width: 256,
                        pyramid: true, strip: true }
      if IiifDerivativeService.s3?
        destination = Aws::S3::Object.new(Settings.aws.buckets.pyramids, IiifDerivativeService.s3_key_for(file_id))
        destination.put(body: image.tiffsave_buffer(output_params))
      else
        output_file = IiifDerivativeService.derivative_path_for(file_id)
        FileUtils.mkdir_p(File.dirname(output_file))
        image.tiffsave(output_file, output_params)
      end
    end
end
