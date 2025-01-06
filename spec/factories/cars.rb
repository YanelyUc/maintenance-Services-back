FactoryBot.define do
  factory :car do
    plate_number { FFaker::Vehicle.vin }
    model { FFaker::Vehicle.model }
    year { rand(1900..Date.today.year) }
  end
end
