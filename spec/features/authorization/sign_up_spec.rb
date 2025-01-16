require 'rails_helper'

feature 'User can sign up', '
  In order to get more abilities
  As guest
  I want to register
' do
  background { visit new_user_registration_path }

  describe 'Unregistered user' do
    scenario 'tries to sign up' do
      fill_in 'Email', with: 'my_mail@mail.m'
      fill_in 'Password', with: '123123'
      fill_in 'Password confirmation', with: '123123'
      click_on 'Sign up'

      email = ActionMailer::Base.deliveries.last
      expect(email).to_not be_nil

      confirmation_link = email.body.to_s.match(/href="([^"]+)"/)[1]
      visit confirmation_link

      expect(page).to have_content 'Your email address has been successfully confirmed'
    end

    scenario 'tries to sign up with wrong data' do
      click_on 'Sign up'

      expect(page).to have_content 'errors prohibited this user from being saved'
    end
  end

  describe 'Registered user' do
    given(:user) { create(:user) }

    scenario 'tries to sign up' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: '1231234'
      fill_in 'Password confirmation', with: '1231234'
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end
