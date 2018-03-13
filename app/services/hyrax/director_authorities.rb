module Hyrax
  # Provide select options for the subject field
  class DirectorAuthorities < QaSelectService
    def initialize
      super('directors')
    end
  end
end
