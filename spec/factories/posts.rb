FactoryBot.define do
  factory :post do
    association :user
    store_name{Faker::Restaurant.name}
    address{Faker::Address.full_address}
    latitude{Faker::Address.latitude}
    longitude{Faker::Address.longitude }
    price{ 800 }
    five_star_rating{ 3 }
    lots_of_vegetables{ true }    
    body {'a'*100}
    post_images { [File.open("#{Rails.root}/spec/fixtures/sample.png")] }
  end
end