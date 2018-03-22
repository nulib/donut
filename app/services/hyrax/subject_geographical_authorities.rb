module Hyrax
  # Provide select options for the subject field
  class SubjectGeographicalAuthorities < QaSelectService
    def initialize
      super('subjects_geographical')
    end
  end
end
