require 'rails_helper'

feature 'User can create comment', "
  In order to discuss content
  As an authenticated user
  I'd like to be able to add comments to questions and answers
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds a comment to a question' do
      within "#question#{question.id}" do
        expect(page).to have_selector('.add-comment-link')
        click_link 'Add Comment'

        expect(page).to have_selector('.new-comment')
        fill_in 'comment[body]', with: 'Comment for question'
        click_button 'Save'

        element = find('.comments')
        expect(element).to have_content 'Comment for question'
      end
    end

    scenario 'adds a comment to an answer' do
      within "#answer_#{answer.id}" do
        click_link 'Add Comment'

        fill_in 'comment[body]', with: 'Comment for answer'
        click_button 'Save'

        element = find('.comments')
        expect(element).to have_content 'Comment for answer'
      end
    end

    scenario 'adds a comment with errors' do
      within "#question#{question.id}" do
        click_link 'Add Comment'
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to add a comment' do
    visit question_path(question)

    expect(page).to_not have_button 'Add Comment'
  end
end
