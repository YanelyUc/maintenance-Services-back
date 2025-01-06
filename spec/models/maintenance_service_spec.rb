require 'rails_helper'

RSpec.describe MaintenanceService, type: :model do
  let!(:maintenance_service) { create(:maintenance_service) }

  describe 'validations' do
    it 'create with valid attributes' do
      expect(maintenance_service).to be_valid
    end

    it 'when not has description' do
      maintenance_service.description = nil
      expect(maintenance_service).to_not be_valid
    end

    it 'when not has date' do
      maintenance_service.date = nil
      expect(maintenance_service).to_not be_valid
    end

    it 'when date is invalid' do
      maintenance_service.date = Date.new(2026, 01, 02)
      expect(maintenance_service).to_not be_valid
    end
  end

  describe 'scope' do
    it 'return active maintenance service' do
      active_maintenance_service = create(:maintenance_service)
      inactive_maintenance_service = create(:maintenance_service, active: false)

      expect(MaintenanceService.active).to include(active_maintenance_service)
      expect(MaintenanceService.active).to_not include(inactive_maintenance_service)
    end
  end

  describe 'relations' do
    it 'return a car' do
      car = create(:car)
      service = create(:maintenance_service, car: car)

      expect(service.car).to eql(car)
    end
  end
end
