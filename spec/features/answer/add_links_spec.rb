require 'rails_helper'

feature 'User can add links to answer', "{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
}" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://github.com' }

  scenario 'User adds link when give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer[body]', with: 'My answer with link'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_button 'Submit Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end