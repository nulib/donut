module Hyrax
  class PrinterAuthorities < QaSelectService
    def initialize
      super('printers')
    end
  end
end
