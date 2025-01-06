require 'rails_helper'

RSpec.describe Car, type: :model do
    let!(:car) { create(:car) }

    describe 'validations' do
      it 'create with valid attributes' do
        expect(car).to be_valid
      end

      it 'when not has plate_number' do
        car.plate_number = nil
        expect(car).to_not be_valid
      end

      it 'when the plate_number is duplicated' do
        car_duplicate = car.dup
        expect(car_duplicate).to_not be_valid
      end

      it 'when not has year' do
        car.year = nil
        expect(car).to_not be_valid
      end

      it 'when year is invalid' do
        car.year = 2026
        expect(car).to_not be_valid
      end
    end

    describe 'scope' do
      it 'return active cars' do
        active_car = create(:car)
        inactive_car = create(:car, active: false)

        expect(Car.active).to include(active_car)
        expect(Car.active).to_not include(inactive_car)
      end
    end

    describe 'relations' do
      it 'only returns active maintenance services' do
        active_service = create(:maintenance_service, car: car)
        inactive_service = create(:maintenance_service, car: car, active: false)

        expect(car.active_maintenance_services.count).to eql(1)
        expect(car.active_maintenance_services).to include(active_service)
        expect(car.active_maintenance_services).to_not include(inactive_service)
      end
    end
end
