module CommonIndexers
  class FileSet < Base
    def generate
      return {} if files.empty?
      multi_merge(
        model,
        {
          id: files.first.id.split(%r{/}).last,
          digest: digest_from_content,
          simple_title: title
        },
        values(:label, :description, :height, :mime_type,
               :original_checksum, :width, :visibility)
      )
    end

    def digest_from_content
      return unless original_file
      original_file.digest.first.to_s
    end
  end
end
