FactoryBot.define do
  factory :comment do
    user { post.user }
    association :post
    content { 'b' * 10 }
  end
end