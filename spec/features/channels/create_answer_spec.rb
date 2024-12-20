require 'rails_helper'

feature 'User can see answer updates in real time', "
  In order to see a just added answer
  As a user
  I'd like to see how new answer appears without refreshing page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'new answer', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'new answer test text'
        click_on 'Submit Answer'
        expect(page).to have_content 'new answer test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'new answer test text'
      end
    end

    scenario 'answer does not appear twice on different pages' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        fill_in 'Body', with: 'new answer test text'
        click_on 'Submit Answer'
        expect(page).to have_content 'new answer test text'
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_content 'new answer test text'
      end

      Capybara.using_session('user') do
        expect(page).to have_content 'new answer test text'
      end
    end
  end
end
