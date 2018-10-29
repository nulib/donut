require 'rails_helper'

RSpec.describe CrappyStateMachine, type: :model do
  let(:file_set_id) { '67890' }
  let(:job_class) { 'TestJob' }
  let(:job_id) { 'abcde' }
  let(:work_id) { '12345' }
  let(:common_params) { { job_class: job_class, target_id: file_set_id, work_id: work_id, job_id: job_id } }

  describe 'new job' do
    it '#transition' do
      expect { described_class.transition(common_params.merge(state: 'performing')) }.to(change { described_class.count }.by(1))
      expect(described_class.find_by(job_class: job_class, target_id: file_set_id).state).to eq('performing')
    end
  end

  describe 'existing job' do
    before { described_class.transition(common_params.merge(state: 'performing')) }

    it '#transition' do
      expect { described_class.transition(common_params.merge(state: 'performed')) }.not_to(change { described_class.count })
      expect(described_class.find_by(job_class: job_class, target_id: file_set_id).state).to eq('performed')
    end
  end

  describe '#trace' do
    it 'without an error' do
      expect do
        expect { CrappyStateMachine.trace(common_params) { sleep(1) } }.not_to raise_error
      end.to(change { described_class.where(job_class: job_class, target_id: file_set_id, state: 'performed').count }.by(1))
    end

    it 'with an error' do
      expect do
        expect { CrappyStateMachine.trace(common_params) { raise 'Die!' } }.to raise_error(RuntimeError)
      end.to(change { described_class.where(job_class: job_class, target_id: file_set_id, state: 'exception').count }.by(1))
    end
  end
end
