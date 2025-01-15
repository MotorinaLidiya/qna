require 'rails_helper'

RSpec.feature 'User signs in with vkontakte' do
  describe 'User signs in with vkontakte' do
    given!(:user) { create(:user) }

    background { visit new_user_registration_path }

    describe 'login via VK' do
      scenario 'when user exists' do
        mock_auth :vkontakte
        click_on 'Sign in with Vkontakte'
        fill_in 'Email', with: user.email
        click_on 'Confirm Email'

        expect(page).to have_content 'You can log in'
      end

      scenario 'when user does not exist' do
        mock_auth :vkontakte
        click_on 'Sign in with Vkontakte'
        fill_in 'Email', with: 'vkontakte-confirm@gmail.com'
        click_on 'Confirm Email'

        expect(page).to have_content 'Email has been sent to vkontakte-confirm@gmail.com'

        user = User.find_by(email: 'vkontakte-confirm@gmail.com')
        user.send_confirmation_instructions

        confirmation_url = "https://localhost/users/confirmation?confirmation_token=#{user.confirmation_token}"

        visit confirmation_url
        expect(page).to have_content 'Your email address has been successfully confirmed'
      end
    end
  end
end
