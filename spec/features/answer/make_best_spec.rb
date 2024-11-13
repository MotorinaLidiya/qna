require 'rails_helper'

feature 'User can choose best answer', "
  In order to mark solution of question
  As an author of question
  I'd like to be able to choose best answer
" do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  given(:answer_second) { answers.second }
  given!(:answer) { answers.last }

  describe 'Authenticated user' do
    scenario 'tries to mark best an answer to other user question' do
      sign_in(another_user)
      visit question_path(question)

      within "#answer_#{answer_second.id}" do
        expect(page).not_to have_button 'Make best'
      end
    end

    scenario 'marks as best an answer to his question', js: true do
      sign_in user
      visit question_path(question)

      within "#answer_#{answer.id}" do
        click_button 'Make best'

        expect(page).to have_content 'Best answer:'
        expect(page).to have_no_button 'Make best'
      end

      within '.answers' do
        expect(page).to have_css('[id^="answer_"]', count: 3)
        expect(page.find('[id^="answer_"]', match: :first)).to have_content answer.body
      end
    end
  end

  scenario 'Unauthenticated user tries to mark best an answer' do
    visit question_path(question)

    within "#answer_#{answer.id}" do
      expect(page).not_to have_button 'Make best'
    end
  end
end
