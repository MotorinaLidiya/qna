class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :questions

  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 300 }
end
