require 'spec_helper'

describe HomeController do

  describe 'GET index' do
    subject(:do_request) { get :index }

    it_should 'be accessible', as_user
    it_should 'be accessible', as_admin
  end
end
