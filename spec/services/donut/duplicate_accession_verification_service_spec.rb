# frozen_string_literal: true

require 'rails_helper'

describe Donut::DuplicateAccessionVerificationService do
  subject { service.duplicate_ids }

  let(:accession_number)     { 'nul:999' }
  let(:service)              { described_class.new(accession_number) }

  context 'when no duplicate accession numbers exist' do
    before { allow(Image).to receive(:where).with(accession_number_tesim: accession_number).and_return([]) }
    it { is_expected.to be_empty }
  end

  context 'when duplicate accession numbers exist' do
    let(:image) { FactoryBot.create(:image, accession_number: 'nul:999') }

    before do
      allow(Image).to receive(:where).with(accession_number_tesim: accession_number).and_return([image.id])
    end
    it { is_expected.to contain_exactly(image.id) }
  end

  describe '::unique?' do
    subject { described_class.unique?(accession_number) }

    context 'when no duplicate accession numbers exist' do
      before { allow(Image).to receive(:where).with(accession_number_tesim: accession_number).and_return([]) }
      it { is_expected.to be(true) }
    end
  end

  describe '::duplicate?' do
    subject { described_class.duplicate?(accession_number) }

    context 'when duplicate accession numbers exist' do
      let(:image) { FactoryBot.create(:image, accession_number: 'nul:999') }

      before do
        allow(Image).to receive(:where).with(accession_number_tesim: accession_number).and_return([image.id])
      end
      it { is_expected.to be(true) }
    end
  end
end
