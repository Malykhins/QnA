require 'rails_helper'

describe 'Answers API', type: :request do
  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_url) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let!(:links) { create_list(:link, 2, linkable: answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let!(:files) { [
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/file1.txt'), 'text/txt'),
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/file2.txt'), 'text/txt')
      ] }

      before do
        files.each do |file|
          answer.files.attach(file)
        end
      end

      before { get api_url, params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq comments.size
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { answer_response['links'].first }

        it 'returns list of links' do
          expect(answer_response['comments'].size).to eq links.size
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_response) { answer_response['files'].first }

        it 'returns list of files' do
          expect(answer_response['files'].size).to eq 2
        end

        it 'returns filename and URL' do
          expect(file_response['filename']).to eq file.filename.to_s
          expect(file_response['path']).to eq rails_blob_path(file, only_path: true)
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers/' do
    let!(:question) { create(:question) }
    let(:api_url) { "/api/v1/questions/#{question.id}/answers" }
    let(:answer_response) { json['answer'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:links) do
        [{ name: 'first link', url: 'https://first_link.com' },
         { name: 'second link', url: 'https://second_link.com' }]
      end
      let!(:valid_params) do
        { format: :json, access_token: access_token.token, question_id: question.id,
          answer: { body: 'Answer Body', links_attributes: links } }
      end
      let(:invalid_params) do
        { format: :json, access_token: access_token.token, question_id: question.id,
          answer: { body: '', links_attributes: links } }
      end

      it_behaves_like 'API Validatable' do
        let(:method) { :post }
      end

      context 'with valid attributes' do
        before { post api_url, params: valid_params }

        it 'creates new answer' do
          expect(Answer.count).to eq 1
        end

        it 'returns 201 status' do
          expect(response.status).to eq 201
        end

        describe 'links' do
          let(:link) { links.first }
          let(:link_response) { answer_response['links'].first }

          it 'returns list of links' do
            request
            expect(answer_response['links'].size).to eq links.size
          end

          it 'returns name and url' do
            request
            %w[name url].each do |attr|
              expect(link_response[attr]).to eq link[attr.to_sym].as_json
            end
          end
        end
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let(:me) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:answer) { create(:answer, user: me) }
    let(:api_url) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      let(:mine_access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }
      let(:valid_params) { { format: :json, access_token: mine_access_token.token, answer: { body: 'Updated Answer Body' } } }
      let(:invalid_params) { { format: :json, access_token: mine_access_token.token, answer: { body: '' } } }
      let(:other_user_params) {
        { format: :json, access_token: other_access_token.token, answer: { body: 'Updated Answer Body' } }
      }

      it_behaves_like 'API Validatable' do
        let(:method) { :put }
      end

      context 'with valid attributes' do
        before { put api_url, params: valid_params }

        it 'returns 201 status' do
          expect(response.status).to eq 201
        end

        it 'updates the answer' do
          updated_answer = Answer.find(answer.id)
          expect(updated_answer.body).to eq 'Updated Answer Body'
        end
      end

      context 'for not author' do
        before { put api_url, params: other_user_params }

        it 'returns 403 status' do
          expect(response.status).to eq 403
        end

        it 'does not update the answer' do
          updated_answer = Answer.find(answer.id)
          expect(updated_answer.body).to eq 'Answer text'
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:me) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:answer) { create(:answer, user: me) }
    let(:api_url) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:mine_access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }

      context 'for answer author' do
        before { delete api_url, params: { format: :json, access_token: mine_access_token.token } }

        it 'returns json message' do
          expect(json['messages']).to include "Answer was successfully deleted."
        end

        it 'deletes the answer' do
          expect(Answer.count).to eq 0
        end
      end

      context 'for not author' do
        before { delete api_url, params: { format: :json, access_token: other_access_token.token } }

        it 'returns 403 status' do
          expect(response.status).to eq 403
        end

        it 'does not delete the answer' do
          expect { Answer.count }.to_not change { Answer.count }
        end
      end
    end
  end
end
