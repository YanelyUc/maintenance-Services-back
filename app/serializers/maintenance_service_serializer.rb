class MaintenanceServicesSerializer < ActiveModel::Serializer
  attributes :id, :description, :car_id, :status, :date
end
