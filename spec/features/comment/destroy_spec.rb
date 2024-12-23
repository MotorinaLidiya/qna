require 'rails_helper'

feature 'User can delete his comment', "
  In order to remove an comment
  As an author of answer
  I'd like to be able to delete my comment from answer or question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:comment) { create(:comment, author: user, commentable: question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:answer_comment) { create(:comment, author: user, commentable: answer, body: 'Answer comment') }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'removes his comment from question' do
      within "#question#{question.id}" do
        expect(page).to have_content comment.body

        within "#comment_#{comment.id}" do
          click_on 'Delete comment'
        end

        expect(page).to_not have_content comment.body
      end
    end

    scenario 'removes his comment from answer' do
      within "#answer_#{answer.id}" do
        expect(page).to have_content answer_comment.body

        within "#comment_#{answer_comment.id}" do
          click_on 'Delete comment'
        end

        expect(page).to_not have_content answer_comment.body
      end
    end
  end

  scenario 'Unauthenticated user tries to remove other comment' do
    visit question_path(question)

    expect(page).to_not have_selector("delete-#{comment.id}", text: 'Delete comment')
  end
end
