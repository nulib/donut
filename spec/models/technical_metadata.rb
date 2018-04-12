require 'rails_helper'

# rubocop:disable RSpec/FilePath
RSpec.describe TechnicalMetadata do
  subject(:techmd) { FactoryBot.build(:technical_metadata) }

  it_behaves_like 'a model with technical metadata'
end
# rubocop:enable RSpec/FilePath
