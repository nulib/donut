require 'ruby-vips'

module Donut
  class FileSetDerivativesService < Hyrax::FileSetDerivativesService
    def create_derivatives(filename)
      prepped_file = prepare_file(filename)
      super(prepped_file).tap do
        if file_set.class.image_mime_types.include?(mime_type)
          file = file_for(filename)
          file_id = file.id
          CreatePyramidTiffJob.perform_later(file_set, file_id)
        end
      end
    end

    def prepare_file(filename)
      return filename unless file_set.class.image_mime_types.include?(mime_type) && file_set.area_of_interest.present?
      ext = File.extname(filename)
      File.join(File.dirname(filename), "#{File.basename(filename, ext)}_cropped#{ext}").tap do |cropped_filename|
        create_cropped_file(filename, cropped_filename)
      end
    end

    private

      def create_cropped_file(source, target)
        return target if File.exist?(target)
        x, y, width, height, rotation = file_set.area_of_interest.split(',').collect(&:to_i)
        image = Vips::Image.new_from_file(source).extract_area(x, y, width, height).rot(:"d#{rotation}")
        savetype = mime_type.split(%r{/}).last
        image.send("#{savetype}save", target)
      end

      def file_for(filename)
        file_set.files.to_a.find { |f| f.original_name == filename } || file_set.original_file
      end
  end
end
