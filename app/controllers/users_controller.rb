class UsersController < ApplicationController
  before_action :authenticate_user!

  def rewards
    @rewards = current_user.rewards.includes(:question)
  end
end
