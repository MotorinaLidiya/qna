require 'rails_helper'

feature 'User can react to answers with likes or dislikes', "
  In order to express approval or disapproval of an answer
  As an authenticated user
  I'd like to be able to leave a like or dislike reaction
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:user_answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'puts reaction to question' do
      within "#reaction_#{question.id}" do
        expect(page).to have_content 'Rating: 0'

        click_button 'Like'
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_button 'Like', class: 'btn-success'
      end
    end

    scenario 'puts reaction to answer' do
      within "#reaction_#{answer.id}" do
        expect(page).to have_content 'Rating: 0'

        click_button 'Dislike'
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_button('Dislike', class: 'btn-danger')
      end
    end

    scenario 'puts reaction on own content' do
      visit question_path(user_answer.question)

      within "#reaction_#{user_answer.id}" do
        expect(page).not_to have_button 'Like'
        expect(page).not_to have_button 'Dislike'
      end
    end

    scenario 'removes reaction' do
      within "#reaction_#{answer.id}" do
        click_button 'Like'
        expect(page).to have_content 'Rating: 1'

        click_button 'Like'
        expect(page).to have_content 'Rating: 0'
        expect(page).to have_button('Like', class: 'btn-outline-success')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to react to a question or answer' do
      visit question_path(question)

      within "#reaction_#{question.id}" do
        expect(page).not_to have_button 'Like'
        expect(page).not_to have_button 'Dislike'
      end

      within "#reaction_#{answer.id}" do
        expect(page).not_to have_button 'Like'
        expect(page).not_to have_button 'Dislike'
      end
    end
  end
end
