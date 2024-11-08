class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :answers

  belongs_to :question

  validates :body, presence: true, length: { maximum: 300 }

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  def mark_as_best
    transaction do
      self.class.where(question_id: question_id).find_each do |answer|
        answer.update(best: false)
      end
      update(best: true)
    end
  end
end
