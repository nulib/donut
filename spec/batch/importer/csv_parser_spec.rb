
require 'rails_helper'
require 'importer'

RSpec.describe Importer::CSVParser do
  let(:parser) { described_class.new(File.read(file)) }
  let(:attributes) { parser.attributes }
  let(:file) { "#{fixture_path}/csv/sample.csv" }
  let(:first_record) { parser.first }

  context 'Importing just images' do
    # rubocop:disable RSpec/ExampleLength
    it 'parses a record' do
      # Title must be singular
      expect(first_record[:title]).to eq [
        'Knowing their lines: how social boundaries undermine equity-based integration policies in United States and South African schools'
      ]
      expect(first_record[:admin_set_id]).to contain_exactly('admin_set/default')
      expect(first_record[:file]).to contain_exactly('files/coffee.jpg', 'files/nul.jpg')
      expect(first_record[:date_created]).to contain_exactly('2009-12')
      expect(first_record[:contributor]).to contain_exactly(
        a_hash_including(name: ['Carter, Prudence L.']),
        a_hash_including(name: ['Caruthers, Jakeya']),
        a_hash_including(name: ['Perspectives in Education'])
      )
      expect(first_record.keys).to contain_exactly(:accession_number, :type, :title, :description,
                                                   :subject, :resource_type, :contributor, :style_period,
                                                   :date_created, :file, :collection, :admin_set_id, :subject_topical)
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe 'validating CSV headers' do
    subject(:parsed_headers) { parser.send(:validate_headers, headers) }

    context 'with valid headers' do
      let(:headers) { %w[id title] }

      it 'contains the correct headers' do
        expect(parsed_headers).to eq headers
      end
    end

    context 'with invalid headers' do
      let(:headers) { ['something bad', 'title'] }

      it 'raises an error' do
        expect { parsed_headers }.to raise_error(Importer::CSVParser::ParserError)
      end
    end

    context 'with nil headers' do
      let(:headers) { ['title', nil] }

      it { is_expected.to eq headers }
    end

    # It doesn't expect a matching column for "resource_type"
    context 'with resource_type column' do
      let(:headers) { %w[resource_type title] }

      it { is_expected.to eq headers }
    end
  end

  describe 'validate_header_pairs' do
    subject(:parsed_headers) { parser.send(:validate_header_pairs, headers) }

    context 'with "*_type" columns' do
      let(:headers) { %w[rights_holder rights_holder_type rights_holder title note_type note] }

      it { is_expected.to be_nil }
    end

    # The CSV parser assumes that the *_type column comes just
    # before the column that contains the value for that local
    # authority.  If the columns aren't in the correct order,
    # raise an error.
    context 'with columns in the wrong order' do
      let(:headers) { %w[note note_type rights_holder_type rights_holder_type rights_holder title] }

      it 'raises an error' do
        expect { parsed_headers }.to raise_error(Importer::CSVParser::ParserError, "Invalid headers: 'note_type' column " \
          "must be immediately followed by 'note' column., Invalid headers: " \
          "'rights_holder_type' column must be immediately followed by " \
          "'rights_holder' column.")
      end
    end
  end
end
