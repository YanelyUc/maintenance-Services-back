require "test_helper"

class MaintenanceServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @maintenance_service = maintenance_services(:one)
  end

  test "should get index" do
    get maintenance_services_url, as: :json
    assert_response :success
  end

  test "should create maintenance_service" do
    assert_difference('MaintenanceService.count') do
      post maintenance_services_url, params: { maintenance_service: { car_id: @maintenance_service.car_id, date: @maintenance_service.date, description: @maintenance_service.description, status: @maintenance_service.status } }, as: :json
    end

    assert_response 201
  end

  test "should show maintenance_service" do
    get maintenance_service_url(@maintenance_service), as: :json
    assert_response :success
  end

  test "should update maintenance_service" do
    patch maintenance_service_url(@maintenance_service), params: { maintenance_service: { car_id: @maintenance_service.car_id, date: @maintenance_service.date, description: @maintenance_service.description, status: @maintenance_service.status } }, as: :json
    assert_response 200
  end

  test "should destroy maintenance_service" do
    assert_difference('MaintenanceService.count', -1) do
      delete maintenance_service_url(@maintenance_service), as: :json
    end

    assert_response 204
  end
end
