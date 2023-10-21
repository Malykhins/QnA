require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }

  it { should have_many(:links).dependent(:destroy) }

  it { should belong_to(:question).class_name('Question') }

  it { should belong_to(:user).class_name('User') }

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :links }
end
