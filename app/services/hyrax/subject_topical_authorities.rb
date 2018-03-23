module Hyrax
  # Provide select options for the subject field
  class SubjectTopicalAuthorities < QaSelectService
    def initialize
      super('subjects_topical')
    end
  end
end
