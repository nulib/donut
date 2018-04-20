require 'rails_helper'

RSpec.describe Donut::Retry do
  let(:log_spy) { instance_spy('logger') }

  before do
    allow(Rails).to receive(:logger).and_return(log_spy)
  end

  context 'class methods' do
    it 'does not log the first try' do
      expect(log_spy).not_to have_received(:warn)
      described_class.log_retries('TEST', 0, nil)
    end

    it 'logs retries' do
      described_class.log_retries('TEST', 1, StandardError.new('Exception Message'))
      expect(log_spy).to have_received(:warn).with("TEST: Retry #1. Reason: StandardError: 'Exception Message'")
    end

    it 'provides a backoff handler' do
      expect(described_class.backoff_handler).to be_a(Proc)
      100.times do |i|
        low = i / 2.0
        expect(described_class.backoff_handler.call(i)).to be_between(low, low + i)
      end
    end
  end

  context 'modules' do
    before do
      class LdpTest < ActiveFedora::Base
      end
    end

    after do
      Object.send(:remove_const, :LdpTest)
    end

    describe Donut::Retry::Ldp do
      before do
        stub_request(:any, %r{/rest/})
          .to_return(status: 503).times(2).then
          .to_return(status: 201, body: 'http://foo.org/test/12345')
      end

      it 'retries twice' do
        expect(LdpTest.new.ldp_source.create).to be_a(Ldp::Resource)
        expect(log_spy).to have_received(:warn).with(/LDP: Retry #[12]/).exactly(2).times
      end
    end

    describe Donut::Retry::Solr do
      before do
        stub_request(:post, %r{/solr/})
          .to_return(status: 503).times(2).then
          .to_return(status: 200, body: '{}')
      end

      it 'retries twice' do
        expect(LdpTest.new(id: '12345').update_index).to be_a(Hash)
        expect(log_spy).to have_received(:warn).with(/SOLR: Retry #[12]/).exactly(2).times
      end
    end
  end
end
