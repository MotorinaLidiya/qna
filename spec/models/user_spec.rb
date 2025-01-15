require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should allow_value('test@example.com').for(:email) }
  it { should_not allow_value('invalid_email').for(:email) }

  it { should validate_presence_of :password }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:email) { 'user@mail.ru' }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(FindOrCreateForOauthService).to receive(:new).with(auth, email).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth, email)
    end
  end
end
