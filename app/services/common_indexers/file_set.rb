module CommonIndexers
  class FileSet < Base
    def generate
      multi_merge(
        model,
        values(:id, :label, :description, :visibility)
      )
    end
  end
end
