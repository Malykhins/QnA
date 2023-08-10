FactoryBot.define do
  factory :question do
    sequence(:id) { |n| n }
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
