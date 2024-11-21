class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, format: { with: %r{\Ahttps?://[\S]+\z} }

  def gist?
    url.include?('gist.github.com')
  end
end
