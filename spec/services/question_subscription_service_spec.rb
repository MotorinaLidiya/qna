require 'rails_helper'

RSpec.describe QuestionSubscriptionService do
  let(:service) { described_class.new }
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before do
    ActiveJob::Base.queue_adapter = :test
    question.subscribers << user
  end

  describe '#send_digest' do
    it 'sends digest email to all subscribers' do
      expect(QuestionSubscriptionMailer).to receive(:digest).with(user, question).and_call_original
      service.send_digest(question)
    end

    it 'enqueues the email delivery' do
      expect {
        service.send_digest(question)
      }.to have_enqueued_mail(QuestionSubscriptionMailer, :digest).with(user, question)
    end
  end
end
