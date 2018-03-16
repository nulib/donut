module Hyrax
  # Provide select options for the subject field
  class ScreenwriterAuthorities < QaSelectService
    def initialize
      super('screenwriters')
    end
  end
end
