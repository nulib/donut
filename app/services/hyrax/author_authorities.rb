module Hyrax
  # Provide select options for the subject field
  class AuthorAuthorities < QaSelectService
    def initialize
      super('authors')
    end
  end
end
