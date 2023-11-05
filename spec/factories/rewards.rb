FactoryBot.define do
  factory :reward do
    title { "Cup" }
    question
    association :user, optional: true
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/cup.png") }
  end
end
