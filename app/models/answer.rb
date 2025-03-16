class Answer < ApplicationRecord
  include Authorable
  include Linkable
  include Reactionable
  include Commentable
  include OpenSearch::Model
  include OpenSearch::Model::Callbacks

  belongs_to :question

  has_many_attached :files

  validates :body, presence: true, length: { maximum: 300 }

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  after_create :notify_subscribers

  def mark_as_best
    transaction do
      # rubocop:disable Rails/SkipsModelValidations
      self.class.where(question_id: question_id).update_all(best: false)
      # rubocop:enable Rails/SkipsModelValidations
      update(best: true)
    end

    author.give_reward(question) if question.reward
  end

  def notify_subscribers
    QuestionSubscriptionJob.perform_later(question)
  end
end
