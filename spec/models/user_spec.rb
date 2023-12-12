require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }

  it { should validate_presence_of :password }

  it { should have_many(:answers).class_name('Answer') }

  it { should have_many(:questions).class_name('Question') }

  it { should have_many(:authorizations).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double ('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)

      User.find_for_oauth(auth)
    end
  end
end
