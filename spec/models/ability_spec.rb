require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:self_answer) { create(:answer, user: user) }
    let(:others_answer) { create(:answer, user: other) }
    let(:self_question) { create(:question, user: user) }
    let(:others_question) { create(:question, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    it { should be_able_to :create_comment, Question }
    it { should be_able_to :create_comment, Answer }

    it { should be_able_to :update, self_question }
    it { should_not be_able_to :update, others_question }

    it { should be_able_to :update, self_answer }
    it { should_not be_able_to :update, others_answer }

    it { should be_able_to :destroy, self_question }
    it { should_not be_able_to :destroy, others_question }

    it { should be_able_to :destroy, self_answer }
    it { should_not be_able_to :destroy, others_answer }

    it { should be_able_to :set_best, create(:answer, user: user, question: self_question) }
    it { should_not be_able_to :set_best, create(:answer, user: other, question: others_question) }
  end
end
