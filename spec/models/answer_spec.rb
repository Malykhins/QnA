require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body)}

  it { should belong_to(:question).class_name('Question') }
end

