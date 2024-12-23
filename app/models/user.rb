class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :questions, class_name: 'Question', foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :answers, class_name: 'Answer', foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :comments, class_name: 'Comment', foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :rewards, dependent: :nullify
  has_many :reactions, dependent: :nullify

  def give_reward(question)
    return if rewards.exists?(question.reward.id)

    rewards << question.reward
  end
end
