require 'rails_helper'

feature 'User can see question updates in real time', "
  In order to see a just added question
  As a user
  I'd like to see how new question appears without refreshing page
" do
  given(:user) { create(:user) }
  describe 'new question', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
        click_on 'Ask'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end

    scenario 'question does not appear twice on different pages' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'test text'
        click_on 'Ask'
        expect(page).to have_content 'Test question'
      end

      Capybara.using_session('guest') do
        visit questions_path
        expect(page).to have_content 'Test question'
      end

      Capybara.using_session('user') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'test text'
      end
    end
  end
end
