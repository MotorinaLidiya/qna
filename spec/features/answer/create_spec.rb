require 'rails_helper'

feature 'User can create answer', "
  In order to give answer to community
  As an authenticated user
  I'd like to be able to give an answer
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'gives an answer' do
      fill_in 'answer[body]', with: 'Answer text'
      click_button 'Submit Answer'

      element = find('.answers')
      expect(element).to have_content 'Answer text'
    end

    scenario 'gives an answer with errors' do
      click_button 'Submit Answer'

      element = find('.answer-errors')
      expect(element).to have_content "Body can't be blank"
    end

    scenario 'gives an answer with attached file' do
      fill_in 'answer[body]', with: 'Answer text'
      attach_file 'Files', [Rails.root.join('spec/rails_helper.rb'), Rails.root.join('spec/spec_helper.rb')]
      click_button 'Submit Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    click_on 'Submit Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
