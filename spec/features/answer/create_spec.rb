require 'rails_helper'

feature 'User can create answer', "
  In order to give answer to community
  As an authenticated user
  I'd like to be able to give an answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'gives an answer' do
      fill_in 'Body', with: 'Answer text'
      click_on 'Submit Answer'

      expect(page).to have_content 'Answer text'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer text'
      end
    end

    scenario 'asks a answer with errors' do
      click_on 'Submit Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    click_on 'Submit Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
