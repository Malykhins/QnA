FactoryBot.define do
  factory :question do
    sequence(:id) { |n| n }
    user
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :with_link do
      after(:build) do |question|
        create(:link, linkable: question)
      end
    end
  end
end
