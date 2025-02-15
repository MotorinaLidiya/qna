require 'rails_helper'

RSpec.describe QuestionSubscriptionJob, type: :job do
  let(:question) { create(:question) }
  let(:service) { instance_double(QuestionSubscriptionService) }

  before do
    allow(QuestionSubscriptionService).to receive(:new).and_return(service)
    allow(service).to receive(:send_digest)
  end

  it 'calls QuestionSubscriptionService#send_digest' do
    described_class.perform_now(question)
    expect(service).to have_received(:send_digest).with(question)
  end
end
