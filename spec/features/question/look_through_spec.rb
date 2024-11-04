require 'rails_helper'

feature 'User can look through all questions', '
  In order to find appropriate answers
  Any user
  Is able to see questions list
' do

  describe 'Any user' do
    given!(:questions) { create_list(:question, 3) }

    scenario 'is able to see questions list' do
      visit questions_path

      questions.each { |question| expect(page).to have_content question.title }
    end
  end
end
