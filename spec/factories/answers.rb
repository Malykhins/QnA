FactoryBot.define do
  factory :answer do
    user
    body { 'Answer text' }
    best { false }

    trait :invalid do
      body { nil }
    end
  end
end
