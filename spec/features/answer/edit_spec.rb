require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer' do
      within "#answer_#{answer.id}", visible: false do
        click_on 'Edit'
        fill_in 'Your answer', with: 'Edited Answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited Answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      within "#answer_#{answer.id}", visible: false do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'loads file into his answer and deletes attached file' do
      within "#answer_#{answer.id}" do
        click_on 'Edit'
        attach_file 'Add file', Rails.root.join('spec/rails_helper.rb')
        click_on 'Save'
        expect(page).to have_link 'rails_helper.rb'

        find('.edit-answer-link').click
        click_link 'Remove'
        click_on 'Save'
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'can load files a few times' do
      within "#answer_#{answer.id}" do
        click_on 'Edit'
        attach_file 'Add file', Rails.root.join('spec/rails_helper.rb')
        click_on 'Save'
        expect(page).to have_link 'rails_helper.rb'

        click_on 'Edit'
        attach_file 'Add file', Rails.root.join('spec/spec_helper.rb')
        click_on 'Save'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario "Authenticated user tries to edit other user's answer" do
    sign_in(another_user)

    visit question_path(question)
    expect(page).to_not have_selector('.edit-answer-link', text: 'Edit')
  end

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end
end
