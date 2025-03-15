class Question < ApplicationRecord
  include Authorable
  include Linkable
  include Reactionable
  include Commentable
  include OpenSearch::Model
  include OpenSearch::Model::Callbacks

  has_many :answers, dependent: :destroy
  has_many_attached :files
  has_many :question_subscriptions, dependent: :destroy
  has_many :subscribers, through: :question_subscriptions, source: :user

  has_one :reward, dependent: :nullify

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 300 }

  def as_indexed_json(_options = {})
    as_json(only: %i[id body title]).merge(author_email: author.email)
  end
end
