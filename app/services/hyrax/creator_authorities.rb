module Hyrax
  # Provide select options for the subject field
  class CreatorAuthorities < QaSelectService
    def initialize
      super('creators')
    end
  end
end
