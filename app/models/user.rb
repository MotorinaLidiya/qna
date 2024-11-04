class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :questions, class_name: 'Question', foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
  has_many :answers, class_name: 'Answer', foreign_key: 'author_id', dependent: :destroy, inverse_of: :author
end
