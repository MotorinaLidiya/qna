require 'rails_helper'

feature 'User can search for content', "
  In order to find needed information
  As a user
  I'd like to be able to search for questions, answers, comments, and users
", opensearch: true do
  given!(:user) { create(:user, email: 'search_user@example.com') }
  given!(:question) { create(:question, title: 'Search question', body: 'test question', author: user) }
  given!(:answer) { create(:answer, body: 'Search answer body', question:, author: user) }
  given!(:comment) { create(:comment, body: 'Search comment', commentable: question, author: user) }

  background { visit root_path }

  scenario 'User searches across all models', opensearch: true do
    fill_in 'Введите запрос..', with: 'Search'
    click_on 'Поиск'

    expect(page).to have_content 'Search question'
    expect(page).to have_content 'Search answer body'
    expect(page).to have_content 'Search comment'
    expect(page).to have_content 'search_user@example.com'

    expect(page).not_to have_content 'Ничего не найдено'
  end

  scenario 'User searches for empty content', opensearch: true do
    fill_in 'Введите запрос..', with: 'NonExistentQuery'
    click_on 'Поиск'

    expect(page).to have_content 'Ничего не найдено'
  end
end
