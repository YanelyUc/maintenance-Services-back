class CarSerializer < ActiveModel::Serializer
  attributes :id, :plate_number, :model, :year, :created_at, :updated_at, :active

  has_many :maintenance_services
end
