FactoryBot.define do
  factory :post do
    store_name{Faker::Restaurant.name}
    address{Faker::Address.full_address}
    latitude{Faker::Address.latitude}
    longitude{Faker::Address.longitude }
    post_images { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample.png')) }
    price{ 800 }
    five_star_rating{ 3 }
    lots_of_vegetables{ true }    
    body {'a'*100}
    association :user
  end
end