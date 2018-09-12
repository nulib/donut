module Hyrax
  class CollectorAuthorities < QaSelectService
    def initialize
      super('collectors')
    end
  end
end
