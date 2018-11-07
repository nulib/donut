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
        title: { primary: title },
        modified_date: sortable_date(modified_date),
        create_date: sortable_date(create_date)
      }
    end
  end
end
