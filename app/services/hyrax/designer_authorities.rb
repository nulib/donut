module Hyrax
  # Provide select options for the subject field
  class DesignerAuthorities < QaSelectService
    def initialize
      super('designers')
    end
  end
end
