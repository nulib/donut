module Hyrax
  # Provide select options for the subject field
  class PrinterAuthorities < QaSelectService
    def initialize
      super('printers')
    end
  end
end
