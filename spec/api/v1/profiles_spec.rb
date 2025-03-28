require 'rails_helper'
describe 'Profiles API', type: :request do
  let!(:headers) { { 'CONTENT-TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before { get api_path, params: { access_token: access_token.token }, headers: }

      it_behaves_like 'Successful status'

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: }

      it_behaves_like 'Successful status'

      it 'returns a list of users without current user' do
        expect(json['users'].size).to eq 3
      end

      it "doesn't include current user" do
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end

      it 'returns all public fields for each user' do
        json['users'].each do |user|
          %w[id email].each { |attr| expect(user[attr]).to be_present }
        end
      end

      it "doesn't return private fields" do
        json['users'].each do |user|
          %w[password encrypted_password].each { |attr| expect(user).to_not have_key(attr) }
        end
      end
    end
  end
end
