require 'rails_helper'

describe 'Profiles API', type: :request do

  describe 'GET /api/v1/profiles/me' do
    let!(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }
    let(:method) { :get }
    let(:api_url) { '/api/v1/profiles/me' }
    let(:respond_me) { json['user'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do

      before { do_request method, api_url, params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns id' do
        expect(respond_me['id']).to eq me.id.as_json
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(respond_me[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(respond_me).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_url) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:user) { users.last }
      let!(:me) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:method) { :get }
      let(:respond_users) { json['users'] }

      before { do_request method, api_url, params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(respond_users.size).to eq 2
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(respond_users.last[attr]).to eq user.send(attr).as_json
        end
      end

      it 'not return an authenticated user' do
        respond_users.each do |user_json|
          expect(user_json['id']).to_not eq me.id.as_json
        end
      end
    end
  end
end
