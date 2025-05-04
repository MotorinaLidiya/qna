class Comment < ApplicationRecord
  include Authorable
  include OpenSearch::Model
  include OpenSearch::Model::Callbacks

  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true, length: { maximum: 300 }
end
