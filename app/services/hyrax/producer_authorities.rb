module Hyrax
  class ProducerAuthorities < QaSelectService
    def initialize
      super('producers')
    end
  end
end
