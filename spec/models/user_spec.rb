require 'rails_helper'

RSpec.describe User do
  it '.batch_user' do
    expect(described_class.batch_user.email).to eq(Settings.system_user)
  end

  it '.audit_user' do
    expect(described_class.audit_user.email).to eq(Settings.system_user)
  end
end
