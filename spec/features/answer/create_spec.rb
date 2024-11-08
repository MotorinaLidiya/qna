require 'rails_helper'

feature 'User can create answer', "
  In order to give answer to community
  As an authenticated user
  I'd like to be able to give an answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background(:each) { sign_in(user) }

    scenario 'gives an answer', js: true do
      visit question_path(question)
      fill_in 'answer[body]', with: 'Answer text'
      click_button 'Submit Answer'

      element = find(".answers")
      expect(element).to have_content 'Answer text'
    end

    scenario 'asks an answer with errors', js: true do
      visit question_path(question)
      click_button 'Submit Answer'

      element = find(".answer-errors")
      expect(element).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    click_on 'Submit Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
