class CreatePyramidTiffJob < ApplicationJob
  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the Hyrax.config.working_path

  MAX_PIXELS = 0x3FFF**2

  def perform(file_set, file_id, filepath = nil)
    filename = vips_file(file_set, file_id, filepath)
    image = Vips::Image.new_from_file(filename)
    scale_factor = (MAX_PIXELS / (image.width * image.height).to_f) * 100
    filename = shrink_file(filename, scale_factor) if scale_factor < 100
    write_tiff(Vips::Image.new_from_file(filename), file_set.id)
  end

  private

    # Check to see if VIPS file exists, and if it's large enough not to have been
    # truncated
    def valid_vips_file?(filename)
      return false unless File.exist?(filename)
      existing_size = File.size(filename)
      existing_image = Vips::Image.new_from_file(filename)
      expected_size = (existing_image.width * existing_image.height * existing_image.bands + 64)
      diff = expected_size - existing_size
      if diff > 32_768
        Rails.logger.warn("#{filename} is #{diff} bytes smaller than expected")
        return false
      end
      true
    end

    def vips_file(file_set, file_id, filepath)
      service = Hyrax::DerivativeService.for(file_set)
      filename = service.prepare_file(Hyrax::WorkingDirectory.find_or_retrieve(file_id, file_set.id, filepath))
      basename = File.basename(filename, File.extname(filename))
      (File.join(File.dirname(filename), basename) + '.v').tap do |result|
        unless valid_vips_file?(result)
          system('vips', 'vipssave', filename, result)
          raise Vips::Error, "Failed to convert #{filename} to #{result}: Exited with status #{$CHILD_STATUS.exitstatus}" unless $CHILD_STATUS.success?
        end
      end
    end

    def shrink_file(filename, scale_factor)
      basename = File.basename(filename, '.v')
      (File.join(File.dirname(filename), basename) + '.resized.v').tap do |result|
        unless valid_vips_file?(result)
          scale_arg = format('%.2f', scale_factor)
          system('vips', 'im_shrink', filename, result, scale_arg, scale_arg)
          raise Vips::Error, "Failed to shrink #{filename} to #{scale_factor}: Exited with status #{$CHILD_STATUS.exitstatus}" unless $CHILD_STATUS.success?
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
