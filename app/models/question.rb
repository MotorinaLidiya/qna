class Question < ApplicationRecord
  include Authorable
  include Linkable
  include Reactionable

  has_many :answers, dependent: :destroy
  has_many_attached :files

  has_one :reward, dependent: :nullify

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 300 }
end
