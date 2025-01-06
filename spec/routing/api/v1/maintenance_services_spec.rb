require 'rails_helper'

describe 'MaintenanceService' do
  it 'create' do
    expect(post: 'api/v1/maintenance_services').to route_to(
      controller: 'api/v1/maintenance_services',
      action: 'create'
    )
  end

  it 'show' do
    expect(get: 'api/v1/maintenance_services/123').to route_to(
      controller: 'api/v1/maintenance_services',
      action: 'show',
      id: '123'
    )
  end

  it 'index' do
    expect(get: 'api/v1/maintenance_services').to route_to(
      controller: 'api/v1/maintenance_services',
      action: 'index'
    )
  end

  it 'update' do
    expect(put: 'api/v1/maintenance_services/123').to route_to(
      controller: 'api/v1/maintenance_services',
      action: 'update',
      id: '123'
    )
  end

  it 'delete' do
    expect(delete: 'api/v1/maintenance_services/123').to route_to(
      controller: 'api/v1/maintenance_services',
      action: 'destroy',
      id: '123'
    )
  end
end
