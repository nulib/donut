require 'rails_helper'

RSpec.describe ActiveJob::QueueAdapters::BetterActiveElasticJobAdapter do
  let(:model)   { FakeModel.new(id: 'abcdef') }
  let(:job)     { JSON.dump(TestJob.new(model).serialize) }
  let(:message) { described_class.send(:build_message, queue_name, job, Time.current) }

  before do
    class FakeModel < ActiveFedora::Base
      include GlobalID::Identification
    end

    class TestJob < ApplicationJob
      queue_as queue_name
    end

    Rails.application.config.active_elastic_job.secret_key_base = Rails.application.secrets[:secret_key_base]

    allow(described_class).to receive(:queue_url).and_return("http://localhost:4567/queues/#{queue_name}")
  end

  after do
    Object.send(:remove_const, :TestJob)
    Object.send(:remove_const, :FakeModel)
  end

  describe 'regular job' do
    let(:queue_name) { 'queued' }

    it 'does not include a message_group_id' do
      expect(message).not_to have_key(:message_group_id)
    end
  end

  describe 'FIFO job' do
    let(:queue_name) { 'queued.fifo' }

    it 'includes a message_group_id' do
      expect(message).to have_key(:message_group_id)
    end
  end
end
