require "rails_helper"

RSpec.describe ::Api::V1::CarsController, type: :controller do
  describe '#create' do
    let!(:car_params) do
      {
        plate_number: FFaker::Vehicle.vin,
        model: FFaker::Vehicle.model,
        year: 2001
      }
    end

    context 'success' do
      it 'success_response' do
        post(:create, params: car_params)

        expect(response).to have_http_status(:created)
        expect(Car.count).to eql(1)
        car = Car.first
        expect(car.active).to be(true)
        expect(car.year <= Date.current.year).to be(true)
        expect(car.plate_number.to_s).to eql(car_params[:plate_number].to_s)
      end
    end

    context 'failed' do
      let(:car) { create(:car) }
      it 'when year is incorrect' do
        car_params[:year] = 2026
        post(:create, params: car_params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql('Year must be less than or equal to 2025')
      end

      it 'when not has year' do
        car_params[:year] = nil
        post(:create, params: car_params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql("Year can't be blank, Year is not a number")
      end

      it 'when year has a incorrect format' do
        car_params[:year] = 'dos mil diez'
        post(:create, params: car_params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql('Year is not a number')
      end

      it 'when not has plate_number' do
        car_params[:plate_number] = nil
        post(:create, params: car_params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql("Plate number can't be blank")
      end

      it 'when the plate_number is duplicated' do
        car_params[:plate_number] = car.plate_number
        post(:create, params: car_params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql('Plate number has already been taken')
      end
    end
  end

  describe '#index' do
    let!(:active_car) { create(:car) }
    let!(:second_active_car) { create(:car) }
    let!(:inactive_car) { create(:car, active: false) }

    let(:params) { { filter_status: 'deleted' } }

    context 'success' do
      it 'get only active registers' do
        get(:index)

        expect(response).to have_http_status(:ok)
        expect(json_response[:data].count).to eql(2)
        expect(json_response[:data].pluck(:plate_number)).to include(active_car.plate_number)
        expect(json_response[:data].pluck(:plate_number)).to include(second_active_car.plate_number)
        expect(json_response[:data].pluck(:plate_number)).to_not include(inactive_car.plate_number)
      end

      it 'get only deleted registers' do
        get(:index, params: params)

        expect(response).to have_http_status(:ok)
        expect(json_response[:data].count).to eql(1)
        expect(json_response[:data].pluck(:plate_number)).to_not include(active_car.plate_number)
        expect(json_response[:data].pluck(:plate_number)).to_not include(second_active_car.plate_number)
        expect(json_response[:data].pluck(:plate_number)).to include(inactive_car.plate_number)
      end

      it 'get all registers' do
        params[:filter_status] = 'both'
        get(:index, params: params)

        expect(response).to have_http_status(:ok)
        expect(json_response[:data].count).to eql(3)
        expect(json_response[:data].pluck(:plate_number)).to include(active_car.plate_number)
        expect(json_response[:data].pluck(:plate_number)).to include(second_active_car.plate_number)
        expect(json_response[:data].pluck(:plate_number)).to include(inactive_car.plate_number)
      end
    end
  end

  describe '#show' do
    let!(:active_car) { create(:car) }
    let!(:inactive_car) { create(:car, active: false) }
    let(:params) { { id: active_car.id } }

    context 'success' do
      it 'get active car response' do
        get(:show, params: params)

        expect(response).to have_http_status(:ok)
        expect(json_response[:id].to_s).to eql(params[:id].to_s)
      end

      it 'get inactive car response' do
        params[:id] = inactive_car.id
        get(:show, params: params)

        expect(response).to have_http_status(:ok)
        expect(json_response[:id].to_s).to eql(params[:id].to_s)
      end
    end

    context 'failed' do
      it 'when not exist car' do
        params[:id] = 'dfdfd'
        get(:show, params: params)

        expect(response).to have_http_status(:not_found)
        expect(json_response[:errors][0][:detail]).to eql("The car with id '#{params[:id]}' doesn't exists")
      end
    end
  end

  describe '#update' do
    let!(:car) { create(:car) }
    let!(:params) { { id: car.id, model: 'Nissan 2007', year: 2023, plate_number: 'aqww2' } }

    context 'success' do
      it 'update active car' do
        put(:update, params: params)

        expect(response).to have_http_status(:ok)
        expect(json_response[:id].to_s).to eql(params[:id].to_s)
        expect(json_response[:model].to_s).to eql(params[:model].to_s)
      end
    end

    context 'failed' do
      let!(:duplicate_car) { create(:car) }
      it 'when not exist car' do
        params[:id] = 'dfdfd'
        put(:update, params: params)

        expect(response).to have_http_status(:not_found)
        expect(json_response[:errors][0][:detail]).to eql("The car with id '#{params[:id]}' doesn't exists")
      end

      it 'when has invalid attributes' do
        params[:year] = 'dos mil diez'
        put(:update, params: params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql('Year is not a number')
      end

      it 'when has duplicate plate number' do
        params[:plate_number] = duplicate_car.plate_number
        put(:update, params: params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql('Plate number has already been taken')
      end
    end
  end

  describe '#delete' do
    let!(:car) { create(:car) }
    let!(:car_with_services) { create(:car) }
    let!(:maintenance_service) { create(:maintenance_service, car: car_with_services) }
    let!(:params) { { id: car.id } }

    context 'success' do
      it 'delete a car' do
        delete(:destroy, params: params)

        expect(response).to have_http_status(:ok)
        expect(car.reload.active).to be(false)
        expect(Car.active.count).to be(1)
      end

      it 'delete car with maintenance services' do
        params[:id] = car_with_services.id
        delete(:destroy, params: params)

        expect(response).to have_http_status(:ok)
        expect(Car.active.count).to be(1)
        expect(car_with_services.reload.active).to be(false)
        expect(car_with_services.maintenance_services.first.active).to be(false)
      end
    end

    context 'failed' do
      it 'when not exist car' do
        params[:id] = 'dfdfd'
        delete(:destroy, params: params)

        expect(response).to have_http_status(:not_found)
        expect(json_response[:errors][0][:detail]).to eql("The car with id '#{params[:id]}' doesn't exists")
      end
    end
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end
end
