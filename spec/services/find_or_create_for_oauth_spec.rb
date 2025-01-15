require 'rails_helper'

RSpec.describe FindOrCreateForOauthService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

  describe '.call' do
    context 'when user already exists' do
      context 'with matching email' do
        let(:email) { user.email }
        subject { FindOrCreateForOauthService.new(auth, email) }

        it 'returns existing user by email' do
          expect(subject.call).to eq user
        end
      end

      context 'with existing authorization' do
        subject { FindOrCreateForOauthService.new(auth, 'facebook@email.com') }

        it 'returns user with existing authorization' do
          user.authorizations.create(provider: 'facebook', uid: '123456')

          expect(subject.call).to eq user
        end
      end

      context 'without authorization' do
        context 'user exists by email' do
          let(:email) { user.email }
          subject { FindOrCreateForOauthService.new(auth, email) }

          it 'does not create a new user' do
            expect { subject.call }.to_not change(User, :count)
          end

          it 'returns the existing user' do
            expect(subject.call).to eq user
          end
        end
      end
    end

    context 'when user does not exist' do
      subject { FindOrCreateForOauthService.new(auth, 'facebook@mail.ru') }

      it 'returns the new user' do
        expect(subject.call).to eq User.find_by(email: 'facebook@mail.ru')
      end
    end
  end
end
