require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #github' do
    let!(:github_data) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '123',
        info: { name: 'Name', email: user.email }
      )
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = mock_auth :github, email: user.email
    end

    it 'finds user with oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(github_data)
      expect(User).to receive(:find_for_oauth).with(github_data, user.email)
      get :github
    end

    context 'user exists' do
      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user is not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'GET #vkontakte' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = mock_auth :vkontakte
    end

    context 'when user exists' do
      before do
        get :vkontakte
      end

      it 'redirects to enter email page' do
        expect(response).to render_template 'shared/email_confirmation'
      end

      context 'logins user' do
        before do
          post :confirm_email, params: { email: user.email }

          get :vkontakte
        end

        it 'logs in the user' do
          expect(controller.current_user).to eq(user)
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'when user does not exist' do
      before do
        get :vkontakte
      end

      it 'does not log in the user' do
        expect(controller.current_user).to be_nil
      end

      it 'redirects to the email confirmation page' do
        expect(response).to render_template 'shared/email_confirmation'
      end
    end
  end

  let(:uid) { '12345' }
  let(:provider) { 'vkontakte' }
  let(:user) { create(:user, email: 'user@example.com') }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    session[:uid] = uid
    session[:provider] = provider
  end

  context 'when email is valid and user exists' do
    before do
      post :confirm_email, params: { email: user.email }
    end

    it 'finds the user by email' do
      expect(User.find_by(email: user.email)).to eq(user)
    end

    it 'creates a new authorization for the user' do
      expect(user.authorizations.count).to eq(1)
      expect(user.authorizations.first.provider).to eq(provider)
      expect(user.authorizations.first.uid).to eq(uid.to_s)
    end
  end

  context 'when email is valid and user does not exist' do
    let(:new_email) { 'new_user@example.com' }

    before do
      post :confirm_email, params: { email: new_email }
    end

    it 'creates a new user with the given email' do
      expect(User.find_by(email: new_email)).not_to be_nil
    end

    it 'creates a new authorization for the user' do
      user = User.find_by(email: new_email)
      expect(user.authorizations.count).to eq(1)
      expect(user.authorizations.first.provider).to eq(provider)
      expect(user.authorizations.first.uid).to eq(uid.to_s)
    end
  end

  context 'when email is invalid' do
    let(:invalid_email) { 'invalid_email' }

    before do
      post :confirm_email, params: { email: invalid_email }
    end

    it 'does not create a user' do
      expect(User.find_by(email: invalid_email)).to be_nil
    end

    it 'does not create an authorization' do
      expect(Authorization.count).to eq(0)
    end
  end
end
