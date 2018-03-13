module Hyrax
  # Provide select options for the subject field
  class EngraverAuthorities < QaSelectService
    def initialize
      super('engravers')
    end
  end
end
