# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { described_class } # the class that includes the concern
  let(:user) { create :user }

  let!(:votable_resource) do
    if model.to_s == 'Answer'
      question = create(:question, user: user)
      create(model.to_s.underscore.to_sym, question: question, user: user)
    else
      create(model.to_s.underscore.to_sym, user: user)
    end
  end

  describe '#vote_up' do
    it 'increment the votes by 1' do
      votable_resource.vote_up(user)
      expect(Vote.last.value).to eq(1)
    end
  end

  describe '#vote_down' do
    it 'increment the votes by -1' do
      votable_resource.vote_down(user)
      expect(Vote.last.value).to eq(-1)
    end
  end

  describe '#voted?' do
    it 'return false if the user has not voted yet' do
      votable_resource.votes.find_by(user: user)&.destroy
      expect(votable_resource.voted?(user)).to be_falsy
    end

    it 'return true if the user has already voted' do
      votable_resource.vote_up(user)

      expect(votable_resource.voted?(user)).to be_truthy
    end
  end

  describe '#unvote' do
    it "reset the user's voice if vote up" do
      votable_resource.vote_up(user)
      votable_resource.unvote(user)

      expect(votable_resource.votes.exists?(user: user)).to be_falsy
    end

    it "reset the user's voice if vote down" do
      votable_resource.vote_down(user)
      votable_resource.unvote(user)

      expect(votable_resource.votes.exists?(user: user)).to be_falsy
    end
  end

  describe '#vote_rating' do
    let(:users) { create_list(:user, 3) }

    it 'check rating score' do
      users.each { |user| votable_resource.vote_up(user) }

      expect(votable_resource.vote_rating).to eq 3
    end
  end
end

