module Hyrax
  # Provide select options for the subject field
  class DraftsmanAuthorities < QaSelectService
    def initialize
      super('draftsmen')
    end
  end
end
