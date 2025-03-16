require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    let(:query) { 'test' }
    let(:scope) { 'questions' }
    let(:service_result) { double }

    before do
      allow(SearchService).to receive(:call).and_return(service_result)
    end

    it 'sets results' do
      get :index, params: { query:, scope: }
      expect(assigns(:results)).to eq(service_result)
    end

    it 'calls SearchService with correct parameters' do
      get :index, params: { query:, scope: }
      expect(SearchService).to have_received(:call).with(query, scope)
    end

    it 'returns empty results when query is blank' do
      get :index, params: { query: '', scope: }
      expect(assigns(:results)).to eq([])
    end
  end
end
