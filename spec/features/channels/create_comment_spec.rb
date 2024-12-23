require 'rails_helper'

feature 'User can see comment updates in real time for question and answer', "
  In order to see a just added comment
  As a user
  I'd like to see how new comment appears without refreshing the page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'new comment appears on another user page without duplication', js: true do
    scenario 'for question' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within "#question#{question.id}" do
          click_link 'Add Comment'

          fill_in 'comment[body]', with: 'new question comment'
          click_on 'Save'

          expect(page).to have_content 'new question comment'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_content 'new question comment'
      end

      Capybara.using_session('user') do
        expect(page).to have_content 'new question comment', count: 1
      end
    end

    scenario 'for answer' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within "#answer_#{answer.id}" do
          click_link 'Add Comment'

          fill_in 'comment[body]', with: 'new answer comment'
          click_on 'Save'

          expect(page).to have_content 'new answer comment'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_content 'new answer comment'
      end

      Capybara.using_session('user') do
        expect(page).to have_content 'new answer comment', count: 1
      end
    end
  end
end
