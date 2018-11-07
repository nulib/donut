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
        modified_date: Hyrax::TimeService.time_in_utc.iso8601
      }
    end
  end
end
