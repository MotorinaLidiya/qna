require 'rails_helper'

RSpec.describe SearchService do
  describe '.call' do
    let(:query) { 'test' }

    context 'when searching in all models' do
      it 'calls search on all models' do
        SearchService::MODELS.each_value do |model|
          expect(model).to receive(:search).with(
            query: {
              multi_match: {
                query:,
                fields: SearchService::FIELDS[model.name] || []
              }
            }
          ).and_return(double(records: []))
        end

        SearchService.call(query)
      end
    end

    SearchService::MODELS.each do |scope, model|
      context "when searching in #{scope}" do
        it "calls search only on #{model}" do
          SearchService::MODELS.each_value do |m|
            if m == model
              expect(m).to receive(:search).with(
                query: {
                  multi_match: {
                    query:,
                    fields: SearchService::FIELDS[m.name] || []
                  }
                }
              ).and_return(double(records: []))
            else
              expect(m).not_to receive(:search)
            end
          end

          SearchService.call(query, scope)
        end
      end
    end
  end
end
