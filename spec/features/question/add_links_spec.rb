require 'rails_helper'

feature 'User can add links to question', "{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
}" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://github.com' }
  given(:link_url) { 'https://link.com' }

  describe 'User adds' do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'link when asks question' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'many links when asks question', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_link 'Add one more link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: link_url
      end

      click_on 'Ask'

      within '.questions' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'My link', href: link_url
      end
    end
  end
end
