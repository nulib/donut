require 'rails_helper'

RSpec.describe Donut::SeedDataService do
  let(:seed) { YAML.safe_load(File.read("#{file_fixture_path}/test_seed.yml"), [Symbol]) }

  describe '#load' do
    before do
      AdminSet.destroy_all
      User.destroy_all
      described_class.load(seed)
    end

    it 'populates the admin sets from the seed' do
      expect(AdminSet.count).to eq 11
    end

    it 'populates users from the seed' do
      expect(User.count).to eq 9
    end
  end

  describe '#dump' do
    let(:dump) { described_class.dump }

    before do
      described_class.load(seed)
    end

    it 'writes admin_sets to a seed' do
      expect(dump[:admin_sets].size).to eq seed[:admin_sets].size
    end

    it 'writes users to a seed' do
      expect(dump[:users].size).to eq seed[:users].size
    end
  end
end
