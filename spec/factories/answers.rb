FactoryBot.define do
  sequence :body do |n|
    "Answer text #{n}"
  end
  factory :answer do
    user
    body

    trait :invalid do
      body { nil }
    end
  end
end
