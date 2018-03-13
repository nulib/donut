module Hyrax
  # Provide select options for the subject field
  class ArchitectAuthorities < QaSelectService
    def initialize
      super('architects')
    end
  end
end
