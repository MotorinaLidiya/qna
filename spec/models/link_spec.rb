require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#gist?' do
    it 'returns true for a GitHub gist url' do
      link = Link.new(url: 'https://gist.github.com/example/12345')
      expect(link.gist?).to be true
    end

    it 'returns false for a non-gist url' do
      link = Link.new(url: 'https://google.com')
      expect(link.gist?).to be false
    end
  end
end
