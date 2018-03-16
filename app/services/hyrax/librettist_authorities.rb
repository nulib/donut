module Hyrax
  # Provide select options for the subject field
  class LibrettistAuthorities < QaSelectService
    def initialize
      super('librettists')
    end
  end
end
