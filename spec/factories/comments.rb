FactoryBot.define do
  factory :comment do
    body { "MyComment" }
    commentable { nil }
    user
  end
end
