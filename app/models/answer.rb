class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :answers

  belongs_to :question

  has_many_attached :files

  validates :body, presence: true, length: { maximum: 300 }

  scope :sort_by_best, -> { order(best: :desc, created_at: :asc) }

  def mark_as_best
    transaction do
      # rubocop:disable Rails/SkipsModelValidations
      self.class.where(question_id: question_id).update_all(best: false)
      # rubocop:enable Rails/SkipsModelValidations
      update(best: true)
    end
  end

  def remove_files(file_ids)
    return if file_ids.blank?

    file_ids.each do |file_id|
      files.find_by(id: file_id)&.purge
    end
  end
end
