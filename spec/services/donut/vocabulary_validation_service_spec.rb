require 'rails_helper'

RSpec.describe Donut::VocabularyValidationService do
  describe '.valid?' do
    subject { described_class.valid?(uri) }

    context 'with valid Getty uri' do
      let(:uri) { 'http://vocab.getty.edu/ulan/500180874' }

      it { is_expected.to be(true) }
    end

    context 'with valid uri with trailing slash' do
      let(:uri) { 'http://vocab.getty.edu/ulan/500180874/' }

      it { is_expected.to be(true) }
    end

    context 'with valid LCSH uri' do
      let(:uri) { 'http://id.loc.gov/authorities/subjects/sh998877' }

      it { is_expected.to be(true) }
    end

    context 'with valid LCNAF uri - id starts with n' do
      let(:uri) { 'http://id.loc.gov/authorities/names/n2017161213' }

      it { is_expected.to be(true) }
    end

    context 'with valid LCNAF uri - id starts with no|nr|nb' do
      let(:uri) { 'http://id.loc.gov/authorities/names/no2017161213' }

      it { is_expected.to be(true) }
    end

    context 'with valid MARC language code uri' do
      let(:uri) { 'http://id.loc.gov/vocabulary/languages/eng' }

      it { is_expected.to be(true) }
    end

    context 'with a valid https geonames uri' do
      let(:uri) { 'https://sws.geonames.org/4889676' }

      it { is_expected.to be(true) }
    end

    context 'with an invalid http geonames uri' do
      let(:uri) { 'http://sws.geonames.org/4889676' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri' do
      let(:uri) { 'http://vocab.get.edu/ulan/500180874' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid uri - not a uri' do
      let(:uri) { 'I am just a string' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid geonames uri - .www. instead of .sws.' do
      let(:uri) { 'http://www.geonames.org/4891382/' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid geonames uri - extra content at end' do
      let(:uri) { 'http://sws.geonames.org/4891382/evanston.html' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid LCSH uri - id missing sh' do
      let(:uri) { 'http://id.loc.gov/authorities/subjects/98004200' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid LCSH uri - id missing sr' do
      let(:uri) { 'http://id.loc.gov/authorities/subjects/s98004200' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid LCNAF uri - id missing n*' do
      let(:uri) { 'http://id.loc.gov/authorities/names/78086005' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid LCNAF uri - id does not start with n, nr, no, or nb' do
      let(:uri) { 'http://id.loc.gov/authorities/names/nx78086005' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid FAST uri - just fst + id' do
      let(:uri) { 'fst001234' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid FAST uri - id includes fst' do
      let(:uri) { 'http://id.worldcat.org/fast/fst1919741' }

      it { is_expected.to be(false) }
    end

    context 'with an invalid FAST uri - leading zeros in id' do
      let(:uri) { 'http://id.worldcat.org/fast/0001919741' }

      it { is_expected.to be(false) }
    end

    context 'with invalid MARC language uri - no three char code' do
      let(:uri) { 'http://id.loc.gov/vocabulary/languages/spanish' }

      it { is_expected.to be(false) }
    end
  end
end
