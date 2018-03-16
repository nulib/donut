module Hyrax
  # Provide select options for the subject field
  class SponsorAuthorities < QaSelectService
    def initialize
      super('sponsors')
    end
  end
end
