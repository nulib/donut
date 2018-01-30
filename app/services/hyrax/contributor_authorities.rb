module Hyrax
  # Provide select options for the subject field
  class ContributorAuthorities < QaSelectService
    def initialize
      super('contributors')
    end
  end
end
