require 'rails_helper'

describe 'Car' do
  it 'create' do
    expect(post: 'api/v1/cars').to route_to(
      controller: 'api/v1/cars',
      action: 'create'
    )
  end

  it 'show' do
    expect(get: 'api/v1/cars/123').to route_to(
      controller: 'api/v1/cars',
      action: 'show',
      id: '123'
    )
  end

  it 'index' do
    expect(get: 'api/v1/cars').to route_to(
      controller: 'api/v1/cars',
      action: 'index'
    )
  end

  it 'update' do
    expect(put: 'api/v1/cars/123').to route_to(
      controller: 'api/v1/cars',
      action: 'update',
      id: '123'
    )
  end

  it 'delete' do
    expect(delete: 'api/v1/cars/123').to route_to(
      controller: 'api/v1/cars',
      action: 'destroy',
      id: '123'
    )
  end
end
