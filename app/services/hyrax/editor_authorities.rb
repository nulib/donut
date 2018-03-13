module Hyrax
  # Provide select options for the subject field
  class EditorAuthorities < QaSelectService
    def initialize
      super('editors')
    end
  end
end
