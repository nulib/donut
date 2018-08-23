module CommonIndexers
  class AdminSet < Base
    def generate
      multi_merge(
        model,
        fields,
        values(:description, :visibility)
      )
    end

    def fields
      {
        id: id,
        title: { primary: title }
      }
    end
  end
end
