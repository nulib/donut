module Hyrax
  class DonorAuthorities < QaSelectService
    def initialize
      super('donors')
    end
  end
end
