module Hyrax
  # Provide select options for the subject field
  class PhotographerAuthorities < QaSelectService
    def initialize
      super('photographers')
    end
  end
end
