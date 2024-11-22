require 'rails_helper'

feature 'User can create reward with question', "
  In order to give reward to best answer
  As an authenticated user
  I'd like to be able to create reward
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'creates a question with a reward' do
      fill_in 'Title', with: 'title of question'
      fill_in 'Body', with: 'text of question'

      fill_in 'Reward title', with: 'Best Answer'
      attach_file 'Upload image', Rails.root.join('app/assets/images/image.jpg')
      click_on 'Ask'

      expect(Question.count).to eq(1)
      expect(Reward.count).to eq(1)

      reward = Reward.last
      expect(reward.reward_title).to eq('Best Answer')
      expect(reward.question).to eq(Question.last)
    end
  end
end
