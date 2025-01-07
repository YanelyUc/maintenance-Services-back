FactoryBot.define do
  factory :maintenance_service do
    description { FFaker::Lorem.phrase }
    date { Date.today - rand(0..900) }
    car { association(:car) }
  end
end
