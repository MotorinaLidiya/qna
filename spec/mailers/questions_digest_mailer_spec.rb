require 'rails_helper'

RSpec.describe QuestionsDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { QuestionsDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily Questions Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([ENV.fetch('YANDEX_EMAIL')])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Daily Questions Digest')
    end
  end
end
