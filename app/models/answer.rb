class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :answers

  belongs_to :question

  validates :body, presence: true, length: { maximum: 300 }
end
