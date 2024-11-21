class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :image

  validates :title, presence: true, length: { maximum: 50 }
  validates :image, presence: true
end
