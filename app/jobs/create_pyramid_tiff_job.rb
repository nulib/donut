require 'ruby-vips'

class CreatePyramidTiffJob < ApplicationJob
  # @param [FileSet] file_set
  # @param [String] file_id identifier for a Hydra::PCDM::File
  # @param [String, NilClass] filepath the cached file within the Hyrax.config.working_path
  def perform(file_set, file_id, filepath = nil)
    filename = Hyrax::WorkingDirectory.find_or_retrieve(file_id, file_set.id, filepath)

    image = Vips::Image.new_from_file(filename)
    write_tiff(image, file_id)
  end

  private

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
