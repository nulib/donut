require 'rails_helper'

RSpec.describe BatchItem, type: :model do
  subject { batch.batch_items.create(accession_number: accession_number, attribute_hash: attributes, row_number: 1) }

  let(:batch_item) { subject }
  let(:submitter) { 'jqdoe@example.edu' }
  let(:job_id) { 'e5942432-cfd1-46f0-ba44-67d5fdd2b6e0' }
  let(:original_filename) { 'path/to/batch_file.csv' }
  let(:batch_location) { "s3://test-bucket/#{original_filename}" }
  let(:batch) { Batch.create(submitter: submitter, job_id: job_id, original_filename: original_filename) }
  let(:accession_number) { SecureRandom.uuid }
  let(:common_attributes) do
    {
      accession_number: accession_number,
      type: 'Image',
      title: ['Title'],
      contributor: [{ name: ['Contributor, Prudence L.'] }],
      date_created: ['2018'],
      collection: { id: 'test-collection-id', title: ['Test Collection'] },
      admin_set_id: ['admin_set/default'],
      batch_location: batch_location,
      preservation_level: '2',
      status: ['reviewed'],
      rights_statement: ['http://rights_statement']
    }
  end

  context 'no items' do
    it 'batch should be empty' do
      expect(batch.status).to eq('empty')
    end
  end

  context 'initialization' do
    let(:attributes) { {} }

    it { is_expected.to have_attributes(status: 'initialized') }
    it 'batch should be initialized' do
      expect(batch_item.batch.status).to eq('initialized')
    end
  end

  context 'valid item with accession number' do
    let(:attributes) { common_attributes }

    it 'completes successfully' do
      expect { batch_item.run }.to change { batch_item.status }.from('initialized').to('complete')
      expect(batch_item.batch.status).to eq('complete')
    end
  end

  context 'invalid item with accession number' do
    let(:attributes) { common_attributes.reject { |k, _v| k == :title } }

    it 'errors on :title' do
      batch_item.run
      expect(batch_item.status).to eq('error')
      expect(batch_item.error.keys).to eq([:title])
      expect(batch_item.batch.status).to eq('error')
    end
  end

  context 'valid item without accession number' do
    let(:attributes) { common_attributes.reject { |k, _v| k == :accession_number } }

    it 'errors on :accession_number' do
      batch_item.run
      expect(batch_item.status).to eq('error')
      expect(batch_item.error.keys).to eq([:accession_number])
      expect(batch_item.batch.status).to eq('error')
    end
  end

  context 'invalid item without accession number' do
    let(:accession_number) { nil }
    let(:attributes) { common_attributes.reject { |k, _v| k == :title } }

    it 'errors on both :title and :accession_number' do
      batch_item.run
      expect(batch_item.status).to eq('error')
      expect(batch_item.error.keys).to eq([:title, :accession_number])
      expect(batch_item.batch.status).to eq('error')
    end
  end

  context 'duplicate of already completed item' do
    let(:attributes) { common_attributes }
    let(:prior_batch) { Batch.create(submitter: submitter, job_id: job_id.reverse, original_filename: original_filename) }
    let(:prior_item) { prior_batch.batch_items.create(accession_number: accession_number, attribute_hash: attributes, row_number: 1) }

    it 'is skipped' do
      prior_item.complete!
      expect { batch_item.run }.to change { batch_item.status }.from('initialized').to('skipped')
    end
  end
end
