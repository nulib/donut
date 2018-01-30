module Hyrax
  # Provide select options for the subject field
  class SubjectAuthorities < QaSelectService
    def initialize
      super('subjects')
    end
  end
end
