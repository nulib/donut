module Hyrax
  class ProductionManagerAuthorities < QaSelectService
    def initialize
      super('production_managers')
    end
  end
end
