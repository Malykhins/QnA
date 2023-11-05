require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should validate_presence_of :title }

  it { should belong_to(:question).class_name('Question') }

  it { should belong_to(:user).class_name('User').optional }

  it 'has one attached file' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
