require 'rails_helper'

feature 'User can edit links of answer', "{
  In order to change additional info to my answer
  As an answer's author
  I'd like to be able to edit links
}" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, author: user) }
  given!(:yandex_link) { create(:link, linkable: answer) }
  given(:link_url) { 'https://link.com' }

  describe 'User', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits link of his question' do
      within "#answer_#{answer.id}" do
        click_link 'Edit'
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: link_url
        click_on 'Save'
      end

      expect(page).to have_link 'My link', href: link_url
    end

    scenario 'deletes link of his question', js: true do
      within "#answer_#{answer.id}" do
        click_link 'Edit'
        click_link 'Delete link'
        click_on 'Save'
      end

      expect(page).to_not have_link 'Yandex', href: 'https://yandex.ru'
    end
  end
end
