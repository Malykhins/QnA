require 'rails_helper'
require Rails.root.join "spec/concerns/votable_spec.rb"

RSpec.describe Question, type: :model do
  it_behaves_like "votable"

  it { should validate_presence_of :title }

  it { should validate_presence_of :body }

  it { should have_many(:answers).class_name('Answer').dependent(:destroy) }

  it { should have_many(:links).class_name('Link').dependent(:destroy) }

  it { should belong_to(:user).class_name('User') }

  it { should accept_nested_attributes_for :links }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
