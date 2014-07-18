require 'spec_helper'

describe Admin::HomeController do

  describe 'GET index' do
    subject(:do_request) { get :index }

    it_behaves_like 'a logged action'

    it_should 'be forbidden', as_user
    it_should 'be accessible', as_admin
  end
end
