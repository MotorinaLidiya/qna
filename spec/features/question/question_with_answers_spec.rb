require 'rails_helper'

RSpec.feature 'User views question and its answers', "
  In order to get information about the question
  Any user
  I'd like to be able to see the question and its answers
" do
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 3, question: question) }

  background { visit question_path(question) }

  describe 'Authorized user' do
    given(:user) { create(:user) }

    scenario 'tries to see answers to certain question' do
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end

  describe 'Unauthorized user' do
    scenario 'tries to see answers to certain question' do
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end
end
