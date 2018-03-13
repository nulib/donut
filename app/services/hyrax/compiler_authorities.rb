module Hyrax
  # Provide select options for the subject field
  class CompilerAuthorities < QaSelectService
    def initialize
      super('compilers')
    end
  end
end
