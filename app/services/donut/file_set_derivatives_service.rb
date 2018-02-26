module Donut
  class FileSetDerivativesService < Hyrax::FileSetDerivativesService
    def create_derivatives(filename)
      super.tap do
        if file_set.class.image_mime_types.include?(mime_type)
          file = file_set.files.to_a.find { |f| f.original_name == filename } || file_set.original_file
          file_id = file.id
          CreatePyramidTiffJob.perform_later(file_set, file_id)
        end
      end
    end
  end
end
