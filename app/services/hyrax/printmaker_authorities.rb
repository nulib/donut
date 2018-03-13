module Hyrax
  # Provide select options for the subject field
  class PrintmakerAuthorities < QaSelectService
    def initialize
      super('printmakers')
    end
  end
end
