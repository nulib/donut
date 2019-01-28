require 'rails_helper'

RSpec.describe Donut::VocabularyValidationService do
  describe '.valid?' do
    subject { described_class.valid?(uri) }

    context 'with valid uri' do
      let(:uri) { 'http://vocab.getty.edu/ulan/500180874' }

      it { is_expected.to be(true) }
    end

    context 'with valid uri with trailing slash' do
      let(:uri) { 'http://vocab.getty.edu/ulan/500180874/' }

      it { is_expected.to be(true) }
    end

    context 'with an invalid uri' do
      let(:uri) { 'http://vocab.get.edu/ulan/500180874' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri - not a uri' do
      let(:uri) { 'I am just a string' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri - wrong geonames format' do
      let(:uri) { 'http://www.geonames.org/4891382/' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri - extra content at end of uri' do
      let(:uri) { 'http://sws.geonames.org/4891382/evanston.html' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri - subject heading id missing sh' do
      let(:uri) { 'http://id.loc.gov/authorities/subjects/98004200' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri - names authroity heading id missing n' do
      let(:uri) { 'http://id.loc.gov/authorities/names/78086005' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri - wrong fast format - just fst + id' do
      let(:uri) { 'fst001234' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri - another wrong fast format - includes fst' do
      let(:uri) { 'http://id.worldcat.org/fast/fst1919741' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri - another wrong fast format - leading zeros' do
      let(:uri) { 'http://id.worldcat.org/fast/0001919741' }

      it { is_expected.to be(false) }
    end
  end
end
