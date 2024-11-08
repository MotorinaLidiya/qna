require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      expect(page).to have_css('.edit-question-link')
      find('.edit-question-link').click
    end

    scenario 'edits his question' do
      within "#question#{question.id}" do
        fill_in 'Your question', with: 'Edited title'
        fill_in 'Add description', with: 'Edited body'
        click_on 'Submit Question'

        expect(page).to_not have_content question.body
        expect(page).to have_no_content question.title
        expect(page).to have_content 'Edited title'
        expect(page).to have_content 'Edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
      within "#question#{question.id}" do
        fill_in 'Your question', with: ''
        fill_in 'Add description', with: ''
        click_on 'Submit Question'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "Authenticated user tries to edit other user's question" do
    sign_in(another_user)

    visit question_path(question)
    expect(page).to_not have_selector('.edit-question-link', text: 'Edit')
  end

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
end
