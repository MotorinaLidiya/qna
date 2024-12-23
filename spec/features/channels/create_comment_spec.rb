require 'rails_helper'

feature 'User can see comment updates in real time', "
  In order to see a just added comment
  As a user
  I'd like to see how new comment appears without refreshing page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
end
