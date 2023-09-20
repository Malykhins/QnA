require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }

  it { should validate_presence_of :password }

  it { should have_many(:answers).class_name('Answer') }

  it { should have_many(:questions).class_name('Question') }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_user) { create(:user) }

    it 'returns true if the user is the author of the item' do
      expect(user.author_of?(question)).to eq(true)
    end

    it 'returns false if the user is not the author of the item' do
      expect(another_user.author_of?(question)).to eq(false)
    end
  end
end
