module Hyrax
  # Provide select options for the subject field
  class PresenterAuthorities < QaSelectService
    def initialize
      super('presenters')
    end
  end
end
