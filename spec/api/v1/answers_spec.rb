require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }
  let(:answer) { answers.first }

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful status'

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:valid_params) { { answer: { body: 'New Answer' }, access_token: access_token.token } }

    it_behaves_like 'API Authorizable with object' do
      let(:method) { :post }
      let(:factory) { :answer }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      before { post api_path, params: valid_params.to_json, headers: headers }

      it 'returns 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'saves a new answer' do
        expect(Answer.count).to eq 4
      end

      it 'returns answer with correct fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to be_present
        end
      end
    end

    context 'with invalid params' do
      before do
        post api_path, params: { answer: { body: '' } }.merge(access_token: access_token.token).to_json, headers: headers
      end

      it 'returns 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable with object' do
      let(:method) { :patch }
      let(:factory) { :answer }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.author.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful status'

      context 'with valid attributes' do
        let(:valid_params) do
          { params: { action: :update, format: :json, access_token: access_token.token, answer: { body: 'Updated answer' } } }
        end

        it 'updates the answer' do
          do_request(:patch, api_path, **valid_params)
          expect(answer.reload.body).to eq 'Updated answer'
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) do
          { params: { action: :update, format: :json, access_token: access_token.token, answer: attributes_for(:answer, :invalid) } }
        end

        it "doesn't update answer" do
          expect do
            do_request(:patch, api_path, **invalid_params)
          end.to_not change(answer.reload, :body)
          expect(response.status).to eq 422
        end

        it 'returns 422 status' do
          do_request(:patch, api_path, **invalid_params)
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable with object' do
      let(:method) { :delete }
      let(:factory) { :answer }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.author.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful status'

      let(:request) do
        delete api_path, params: { action: :destroy, format: :json, access_token: access_token.token, answer: answer.id }
      end

      it 'deletes answer' do
        expect do
          request
        end.to change(answer.class, :count).by(-1)
      end

      it 'returns successful status after request' do
        request
        expect(response).to be_successful
      end
    end
  end
end
