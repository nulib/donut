module CommonIndexers
  class FileSet < Base
    def generate
      return {} if files.empty?
      multi_merge(
        model,
        { id: files.first.id.split(%r{/}).last },
        values(:label, :description, :visibility)
      )
    end
  end
end
