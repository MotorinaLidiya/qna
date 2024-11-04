require 'rails_helper'

feature 'User can sign out', '
  In order to terminate session
  As an authenticated user
  Id like to be able to sign out
' do
  given(:user) { create(:user) }
  background { sign_in(user) }

  scenario 'Authenticated user tries to log out' do
    expect(page).to have_button 'Log out'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully'
  end
end
