require "rails_helper"

RSpec.describe ::Api::V1::MaintenanceServicesController, type: :controller do
  describe '#create' do
    let!(:car) { create(:car) }
    let!(:service_params) do
      {
        description: FFaker::Lorem.phrase,
        date: Date.today,
        car_id: car.id
      }
    end

    context 'success' do
      it 'success_response' do
        post(:create, params: service_params)

        expect(response).to have_http_status(:created)
        expect(MaintenanceService.count).to eql(1)
        service = MaintenanceService.first
        expect(service.active).to be(true)
        expect(service.date <= Date.current).to be(true)
        expect(service.description.to_s).to eql(service_params[:description].to_s)
      end
    end

    context 'failed' do
      it 'when date is incorrect' do
        service_params[:date] = Date.current + 1.day
        post(:create, params: service_params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql('Date must be less than or equal to today')
      end

      it 'when not has date' do
        service_params[:date] = nil
        post(:create, params: service_params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql("Date can't be blank")
      end

      it 'when not has description' do
        service_params[:description] = nil
        post(:create, params: service_params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql("Description can't be blank")
      end

      it 'when not has a car' do
        service_params[:car_id] = '123'
        post(:create, params: service_params)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors][0][:detail]).to eql('Car must exist')
      end
    end
  end

  describe '#index' do
    let!(:active_service) { create(:maintenance_service) }
    let!(:second_active_service) { create(:maintenance_service) }
    let!(:inactive_service) { create(:maintenance_service, active: false) }

    let(:params) { { filter_status: 'deleted' } }

    context 'success' do
      it 'get only active registers' do
        get(:index)

        expect(response).to have_http_status(:ok)
        expect(json_response[:data].count).to eql(2)
        expect(json_response[:data].pluck(:description)).to include(active_service.description)
        expect(json_response[:data].pluck(:description)).to include(second_active_service.description)
        expect(json_response[:data].pluck(:description)).to_not include(inactive_service.description)
      end

      it 'get only deleted registers' do
        get(:index, params: params)

        expect(response).to have_http_status(:ok)
        expect(json_response[:data].count).to eql(1)
        expect(json_response[:data].pluck(:description)).to_not include(active_service.description)
        expect(json_response[:data].pluck(:description)).to_not include(second_active_service.description)
        expect(json_response[:data].pluck(:description)).to include(inactive_service.description)
      end

      it 'get all registers' do
        params[:filter_status] = 'both'
        get(:index, params: params)

        expect(response).to have_http_status(:ok)
        expect(json_response[:data].count).to eql(3)
        expect(json_response[:data].pluck(:description)).to include(active_service.description)
        expect(json_response[:data].pluck(:description)).to include(second_active_service.description)
        expect(json_response[:data].pluck(:description)).to include(inactive_service.description)
      end
    end
  end

  describe '#show' do
    let!(:active_service) { create(:maintenance_service) }
    let!(:inactive_service) { create(:maintenance_service, active: false) }
    let(:params) { { id: active_service.id } }

    context 'success' do
      it 'get active service response' do
        get(:show, params: params)

        expect(response).to have_http_status(:ok)
        expect(json_response[:id].to_s).to eql(params[:id].to_s)
      end

      it 'get inactive service response' do
        params[:id] = inactive_service.id
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
        expect(json_response[:errors][0][:detail]).to eql("The maintenance service with id '#{params[:id]}' doesn't exists")
      end
    end
  end

  describe '#update' do
    let!(:service) { create(:maintenance_service) }
    let!(:params) do
      { 
        id: service.id,
        description: 'another description',
        date: Date.new(2021, 06, 21),
        status: 'in_progress'
      }
    end

    context 'success' do
      it 'update active service' do
        put(:update, params: params)

        expect(response).to have_http_status(:ok)
        expect(json_response[:id].to_s).to eql(params[:id].to_s)
        expect(json_response[:description].to_s).to eql(params[:description].to_s)
      end
    end

    context 'failed' do
      it 'when not exist service' do
        params[:id] = 'dfdfd'
        put(:update, params: params)

        expect(response).to have_http_status(:not_found)
        expect(json_response[:errors][0][:detail]).to eql("The maintenance service with id '#{params[:id]}' doesn't exists")
      end

      it 'when has invalid attributes' do
        params[:status] = 'paused'
        expect { put(:update, params: params) }.to raise_error("'paused' is not a valid status")
      end
    end
  end

  describe '#delete' do
    let!(:service) { create(:maintenance_service) }
    let!(:params) { { id: service.id } }

    context 'success' do
      it 'delete a service' do
        delete(:destroy, params: params)

        expect(response).to have_http_status(:ok)
        expect(service.reload.active).to be(false)
        expect(MaintenanceService.active.count).to be(0)
      end
    end

    context 'failed' do
      it 'when not exist service' do
        params[:id] = 'dfdfd'
        delete(:destroy, params: params)

        expect(response).to have_http_status(:not_found)
        expect(json_response[:errors][0][:detail]).to eql("The maintenance service with id '#{params[:id]}' doesn't exists")
      end
    end
  end

  def json_response
    JSON.parse(response.body).with_indifferent_access
  end
end
