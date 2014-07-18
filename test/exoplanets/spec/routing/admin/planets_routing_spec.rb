require 'spec_helper'

describe 'admin planets routing' do
  it_should 'routes resources', model: :user, path: 'admin/planets', methods: ALL_CRUD_METHODS
end
