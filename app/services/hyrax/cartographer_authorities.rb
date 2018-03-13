module Hyrax
  # Provide select options for the subject field
  class CartographerAuthorities < QaSelectService
    def initialize
      super('cartographers')
    end
  end
end
