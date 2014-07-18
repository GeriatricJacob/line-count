require 'spec_helper'

describe 'admin users routing' do
  it_should 'routes resources', model: :user, path: 'admin/users', methods: ALL_CRUD_METHODS
end
