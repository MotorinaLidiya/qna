class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :reward_title, presence: true, length: { maximum: 50 }
end
