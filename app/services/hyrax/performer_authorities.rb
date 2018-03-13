module Hyrax
  # Provide select options for the subject field
  class PerformerAuthorities < QaSelectService
    def initialize
      super('performers')
    end
  end
end
