module Authorable
  extend ActiveSupport::Concern

  included do
    belongs_to :author, class_name: 'User'

    scope :by_author, ->(author) { where(author:) }
  end
end
