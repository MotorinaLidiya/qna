class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', inverse_of: :questions

  has_many :answers, dependent: :destroy

  has_many_attached :files

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 300 }

  def remove_files(file_ids)
    return if file_ids.blank?

    file_ids.each do |file_id|
      files.find_by(id: file_id)&.purge
    end
  end
end
