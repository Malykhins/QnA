FactoryBot.define do
  factory :answer do
    user
    body { 'Answer text' }
    question
    best { false }

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      files { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    end

    trait :with_link do
      after(:build) do |answer|
        create(:link, linkable: answer)
      end
    end
  end
end
