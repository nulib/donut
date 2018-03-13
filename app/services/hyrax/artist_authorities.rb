module Hyrax
  # Provide select options for the subject field
  class ArtistAuthorities < QaSelectService
    def initialize
      super('artists')
    end
  end
end
