class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :author_id

  has_many :comments
  has_many :files
  has_many :links

  def files
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true) }
  end
end
