require 'rails_helper'

RSpec.describe QuestionSubscriptionMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let(:mail) { QuestionSubscriptionMailer.digest(user, question) }

  it 'renders the headers' do
    expect(mail.subject).to eq("New Answer for #{question.title}")
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq([ENV.fetch('YANDEX_EMAIL')])
  end

  it 'renders the body' do
    expect(mail.body.encoded).to match(question.title)
    expect(mail.body.encoded).to match(answer.body)
  end
end
