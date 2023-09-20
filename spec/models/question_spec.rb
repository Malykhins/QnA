require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }

  it { should validate_presence_of :body }

  it { should have_many(:answers).class_name('Answer').dependent(:destroy) }

  it { should belong_to(:user).class_name('User') }
end
