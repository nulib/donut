require 'rails_helper'

RSpec.describe CrappyStateMachine, type: :model do
  let(:file_set_id) { '67890' }
  let(:job_class) { 'TestJob' }
  let(:job_id) { 'abcde' }
  let(:work_id) { '12345' }

  describe 'new job' do
    it '#transition' do
      expect do
        described_class.transition(job_class: job_class, target_id: file_set_id, work_id: work_id, job_id: job_id, state: 'performing')
      end.to(change { described_class.count }.by(1))
      expect(described_class.find_by(job_class: job_class, target_id: file_set_id).state).to eq('performing')
    end
  end

  describe 'existing job' do
    before do
      described_class.transition(job_class: job_class, target_id: file_set_id, work_id: work_id, job_id: job_id, state: 'performing')
    end

    it '#transition' do
      expect do
        described_class.transition(job_class: job_class, target_id: file_set_id, work_id: work_id, job_id: job_id, state: 'performed')
      end.not_to(change { described_class.count })
      expect(described_class.find_by(job_class: job_class, target_id: file_set_id).state).to eq('performed')
    end
  end
end
