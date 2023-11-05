FactoryBot.define do
  factory :link do
    name { "Yandex" }
    url { "https://ya.ru" }
    association :linkable
  end
end
