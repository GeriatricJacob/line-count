require 'spec_helper'

describe Admin::PlanetsController do
  describe 'GET index' do
    subject(:do_request) { get :index }

    it_behaves_like 'an admin action'
  end

  describe 'GET show' do
    let(:planet) { create :planet }
    subject(:do_request) { get :show, id: planet }

    it_behaves_like 'an admin action'
  end

  describe 'GET new' do
    subject(:do_request) { get :new }

    it_behaves_like 'an admin action'
  end

  describe 'GET edit' do
    let(:planet) { create :planet }
    subject(:do_request) { get :edit, id: planet }

    it_behaves_like 'an admin action'
  end
end
