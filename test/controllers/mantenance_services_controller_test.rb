require "test_helper"

class MantenanceServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mantenance_service = mantenance_services(:one)
  end

  test "should get index" do
    get mantenance_services_url, as: :json
    assert_response :success
  end

  test "should create mantenance_service" do
    assert_difference('MantenanceService.count') do
      post mantenance_services_url, params: { mantenance_service: { car_id: @mantenance_service.car_id, date: @mantenance_service.date, description: @mantenance_service.description, status: @mantenance_service.status } }, as: :json
    end

    assert_response 201
  end

  test "should show mantenance_service" do
    get mantenance_service_url(@mantenance_service), as: :json
    assert_response :success
  end

  test "should update mantenance_service" do
    patch mantenance_service_url(@mantenance_service), params: { mantenance_service: { car_id: @mantenance_service.car_id, date: @mantenance_service.date, description: @mantenance_service.description, status: @mantenance_service.status } }, as: :json
    assert_response 200
  end

  test "should destroy mantenance_service" do
    assert_difference('MantenanceService.count', -1) do
      delete mantenance_service_url(@mantenance_service), as: :json
    end

    assert_response 204
  end
end
