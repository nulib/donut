module Hyrax
  # Provide select options for the subject field
  class SculptorAuthorities < QaSelectService
    def initialize
      super('sculptors')
    end
  end
end
