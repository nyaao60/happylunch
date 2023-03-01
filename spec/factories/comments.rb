FactoryBot.define do
  factory :comment do
    user { post.user }
    association :post
    content { 'a' * 10 }
  end
end