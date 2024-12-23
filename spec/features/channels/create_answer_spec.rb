require 'rails_helper'

feature 'User can see answer updates in real time', "
  In order to see a just added answer
  As a user
  I'd like to see how new answer appears without refreshing page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'new answer', js: true do
    scenario 'answer appears on another user page without duplication' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        fill_in 'Body', with: 'new answer text'
        click_on 'Submit Answer'
        expect(page).to have_content 'new answer text'
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_content 'new answer text'
      end

      Capybara.using_session('user') do
        expect(page).to have_content 'new answer text', count: 1
      end
    end
  end
end
