module Hyrax
  # Provide select options for the subject field
  class ComposerAuthorities < QaSelectService
    def initialize
      super('composers')
    end
  end
end
