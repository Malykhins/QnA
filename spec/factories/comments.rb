FactoryBot.define do
  factory :comment do
    body { "MyComment" }
    commentable { nil }
    user { nil }
  end
end
