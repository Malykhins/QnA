require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:controller) { described_class } # the class that includes the concern
  let(:user) { create :user }
  let(:author) { create :user }

  let!(:votable) do
    if controller.to_s == 'AnswersController'
      question = create(:question, user: author)
      create(controller.controller_name.classify.downcase.to_sym, question: question, user: author)
    else
      create(controller.controller_name.classify.downcase.to_sym, user: author)
    end
  end

  describe 'POST #vote_up' do
    context 'the voter is not the author' do
      before { login(user) }

      it 'saves a new vote in data base' do
        expect { post :vote_up, params: { id: votable.id }, format: :js }.to change(Vote, :count).by(1)
      end

      it 'redirects to render json' do
        post :vote_up, params: { id: votable.id }, format: :js
        votable.reload
        expect(JSON.parse(response.body)['rating']).to eq(votable.vote_rating)
        expect(JSON.parse(response.body)['resource_name']).to eq(votable.class.name.downcase)
        expect(JSON.parse(response.body)['resource_id']).to eq(votable.id)
        expect(JSON.parse(response.body)['already_voted']).to eq(votable.voted?(user))
      end
    end

    context 'the voter is an author of votable resource' do
      before { login(author) }

      it 'does not save the vote' do
        expect { post :vote_up, params: { id: votable.id }, format: :js }.to_not change(Vote, :count)
      end

      it 'returns a forbidden status' do
        post :vote_up, params: { id: votable.id }, format: :js
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'the voter is not the author' do
      before { login(user) }

      it 'saves a new vote in data base' do
        expect { post :vote_down, params: { id: votable.id }, format: :js }.to change(Vote, :count).by(1)
      end

      it 'redirects to render json' do
        post :vote_down, params: { id: votable.id }, format: :js
        votable.reload
        expect(JSON.parse(response.body)['rating']).to eq(votable.vote_rating)
        expect(JSON.parse(response.body)['resource_name']).to eq(votable.class.name.downcase)
        expect(JSON.parse(response.body)['resource_id']).to eq(votable.id)
        expect(JSON.parse(response.body)['already_voted']).to eq(votable.voted?(user))
      end
    end

    context 'the voter is an author of votable resource' do
      before { login(author) }

      it 'does not save the vote' do
        expect { post :vote_down, params: { id: votable.id }, format: :js }.to_not change(Vote, :count)
      end

      it 'returns a forbidden status' do
        post :vote_down, params: { id: votable.id }, format: :js
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'DELETE #unvote' do
    context 'the voter is not the author' do
      before do
        login(user)
        votable.vote_up(user)
      end

      it 'deletion of vote from the database' do
        expect { delete :unvote, params: { id: votable.id }, format: :js }.to change(Vote, :count).by(-1)
      end

      it 'redirects to render json' do
        delete :unvote, params: { id: votable.id }, format: :js
        votable.reload
        expect(JSON.parse(response.body)['rating']).to eq(votable.vote_rating)
        expect(JSON.parse(response.body)['resource_name']).to eq(votable.class.name.downcase)
        expect(JSON.parse(response.body)['resource_id']).to eq(votable.id)
        expect(JSON.parse(response.body)['already_voted']).to eq(votable.voted?(user))
      end
    end

    context 'the voter is an author' do
      before do
        login(author)
        votable.vote_up(user)
      end

      it 'does not delete the vote' do
        expect { delete :unvote, params: { id: votable.id }, format: :js }.to_not change(Vote, :count)
      end

      it 'returns a forbidden status' do
        delete :unvote, params: { id: votable.id }, format: :js
        expect(response).to have_http_status(403)
      end
    end
  end
end
