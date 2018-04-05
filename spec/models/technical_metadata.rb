require 'rails_helper'

RSpec.describe TechnicalMetadata do
  subject(:techmd) { FactoryBot.build(:technical_metadata) }

  it_behaves_like 'a model with technical metadata'
end