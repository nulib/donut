module Hyrax
  # Provide select options for the subject field
  class ProducerAuthorities < QaSelectService
    def initialize
      super('producers')
    end
  end
end
