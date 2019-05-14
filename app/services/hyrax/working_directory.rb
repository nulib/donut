module Hyrax
  # @deprecated Use JobIoWrapper instead
  class WorkingDirectory
    class << self
      # Returns the file passed as filepath if that file exists. Otherwise it grabs the file from repository,
      # puts it on the disk and returns that path.
      # @param [String] repository_file_id identifier for Hydra::PCDM::File
      # @param [String] id the identifier of the FileSet
      # @param [String, NilClass] filepath path to existing cached copy of the file
      # @return [String] path of the working file
      def find_or_retrieve(repository_file_id, id, filepath = nil)
        return filepath if filepath && File.exist?(filepath)
        repository_file = Hydra::PCDM::File.find(repository_file_id)
        working_path = full_filename(id, repository_file.original_name)
        if File.exist?(working_path)
          Rails.logger.debug "#{repository_file.original_name} already exists in the working directory at #{working_path}"
          return working_path
        end
        copy_repository_resource_to_working_directory(repository_file, id)
      end

      # @param [ActiveFedora::File] file the resource in the repo
      # @param [String] id the identifier of the FileSet
      # @return [String] path of the working file
      def copy_repository_resource_to_working_directory(file, id)
        Rails.logger.debug "Loading #{file.original_name} (#{file.id}) from the repository to the working directory"
        copy_uri_to_working_directory(id, file.original_name, file.uri.to_s)
      end

      private

        # @param [String] id the identifier
        # @param [String] name the file name
        # @param [#read] uri the location to stream from
        # @return [String] path of the working file
        def copy_uri_to_working_directory(id, name, uri)
          working_path = full_filename(id, name)
          Rails.logger.debug "Writing #{name} to the working directory at #{working_path}"
          FileUtils.mkdir_p(File.dirname(working_path))
          File.open(working_path, 'wb') do |outfile|
            request = Typhoeus::Request.new(uri)
            request.on_body { |chunk| outfile.write(chunk) }
            request.run
          end
          working_path
        end

        def full_filename(id, original_name)
          pair = id.scan(/..?/).first(4).push(id)
          File.join(Hyrax.config.working_path, *pair, original_name)
        end
    end
  end
end
