module Hyrax
  # Provide select options for the subject field
  class ProductionManagerAuthorities < QaSelectService
    def initialize
      super('production_managers')
    end
  end
end
