FactoryBot.define do
  factory :answer do
    user
    body { 'Answer text' }

    trait :invalid do
      body { nil }
    end
  end
end
