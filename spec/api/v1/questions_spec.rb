require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => 'application/json' } }
  let(:access_token) { create(:access_token) }
  let!(:questions) { create_list(:question, 2) }
  let(:question) { questions.first }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: ) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful status'

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user question' do
         expect(question_response['author_id']).to eq question.author_id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful status'

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains author_id' do
        expect(question_response['author_id']).to eq question.author_id
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let!(:answers) { create_list(:answer, 3, question: question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer) { answers.first }
      let(:answers_response) { json['answers'] }
      let(:answer_response) { json['answers'].first }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful status'

      it 'returns list of answers' do
        expect(answers_response.size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:valid_params) { { question: { title: 'New Question', body: 'Question body' } } }

    it_behaves_like 'API Authorizable with object' do
      let(:method) { :post }
      let(:factory) { :question }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      before { post api_path, params: valid_params.merge(access_token: access_token.token).to_json, headers: headers }

      it 'returns 201 status' do
        expect(response).to have_http_status(:created)
      end

      it 'saves a new question' do
        expect(Question.count).to eq 3
      end

      it 'returns question with correct fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to be_present
        end
      end
    end

    context 'with invalid params' do
      before do
        post api_path, params: { question: { title: '', body: '' } }.merge(access_token: access_token.token).to_json, headers: headers
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :patch }

    it_behaves_like 'API Authorizable with object' do
      let(:method) { :patch }
      let(:factory) { :question }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: question.author.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful status'

      context 'with valid attributes' do
        let(:valid_params) do
          { params: { action: :update, format: :json, access_token: access_token.token, question: { body: 'new body', title: 'new title' } } }
        end

        it 'updates the question' do
          do_request(method, api_path, **valid_params)
          expect(question.reload.body).to eq 'new body'
          expect(response).to be_successful
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) do
          { params: { action: :update, format: :json, access_token: access_token.token, question: attributes_for(:question, :invalid) } }
        end

        it "doesn't update question" do
          expect do
            do_request(method, api_path, **invalid_params)
          end.to_not change(question.reload, :body)
          expect(response.status).to eq 422
        end

        it 'returns 422 status' do
          do_request(method, api_path, **invalid_params)
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable with object' do
      let(:method) { :delete }
      let(:factory) { :question }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: question.author.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful status'

      let(:request) do
        delete api_path, params: { action: :destroy, format: :json, access_token: access_token.token, question: question.id }
      end

      it 'deletes question' do
        expect do
          request
        end.to change(question.class, :count).by(-1)
      end

      it 'successful status after request' do
        request
        expect(response).to be_successful
      end
    end
  end
end
