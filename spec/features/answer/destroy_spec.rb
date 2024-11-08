require 'rails_helper'

feature 'User can delete his answer', "
  In order to remove an answer
  As an author of answer
  I'd like to be able to delete my answer
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, body: 'Delete me', question: question, author: user) }

  scenario 'Authenticated user removes his answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete'

    expect(page).to_not have_content answer.body
  end

  scenario 'Unauthenticated user tries to remove other answer' do
    sign_in(another_user)

    expect(page).to_not have_selector("delete-#{answer.id}", text: 'Delete')
  end
end
