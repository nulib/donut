module Hyrax
  # Provide select options for the subject field
  class IllustratorAuthorities < QaSelectService
    def initialize
      super('illustrators')
    end
  end
end
