class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :questions

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 300 }
end
