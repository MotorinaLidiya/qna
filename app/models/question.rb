class Question < ApplicationRecord
  include Authorable
  include Linkable
  include Reactionable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many_attached :files
  has_many :question_subscriptions, dependent: :destroy
  has_many :subscribers, through: :question_subscriptions, source: :user

  has_one :reward, dependent: :nullify

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 300 }

  after_create :calculate_reputation
  after_create :subscribe_author

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_author
    question_subscriptions.create(user: author)
  end
end
