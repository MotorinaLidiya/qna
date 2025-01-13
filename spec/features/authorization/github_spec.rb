require 'rails_helper'

RSpec.feature 'User signs in with GitHub' do
  describe 'User signs in with GitHub' do
    given!(:user) { create(:user, email: 'github-confirm@gmail.com', confirmed_at: nil) }

    background { visit new_user_registration_path }

    describe 'login via GitHub' do
      scenario 'when user exists' do
        mock_auth :github, email: user.email
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      scenario 'when user does not exist' do
        mock_auth :github, email: user.email
        click_on 'Sign in with GitHub'

        user.send_confirmation_instructions

        confirmation_url = "http://localhost/users/confirmation?confirmation_token=#{user.confirmation_token}"
        visit confirmation_url

        expect(page).to have_content 'Your email address has been successfully confirmed'
      end
    end
  end
end
