require 'spec_helper'

describe Admin::UsersController do
  describe 'GET index' do
    subject(:do_request) { get :index }

    it_behaves_like 'an admin action'
  end

  describe 'GET show' do
    let(:target_user) { create :user }
    subject(:do_request) { get :show, id: target_user }

    it_behaves_like 'an admin action'
  end

  describe 'GET new' do
    subject(:do_request) { get :new }

    it_behaves_like 'an admin action'
  end

  describe 'GET edit' do
    let(:target_user) { create :user }
    subject(:do_request) { get :edit, id: target_user }

    it_behaves_like 'an admin action'
  end

  describe 'POST create' do
    let(:params) do
      {
        email: Faker::Internet.email,
        password: 'foobar02',
        password_confirmation: 'foobar02',
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name
      }
    end

    subject(:do_request) { post :create, user: params }

    it_behaves_like 'an admin action'

    when_logged_in as_admin do
      it 'should have created a user' do
        expect { do_request }.to change { User.count }.by(1)
      end
    end
  end

  describe 'PUT update' do
    let(:target_user) { create :user }
    let(:params) do
      {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
      }
    end
    subject(:do_request) { put :create, id: target_user, user: params }

    it_behaves_like 'an admin action'
  end

  describe 'DELETE destroy' do
    let(:target_user) { create :user }
    subject(:do_request) { delete :destroy, id: target_user }

    it_behaves_like 'an admin action'

    when_logged_in as_admin do
      it 'should have destroyed the user' do
        target_user
        expect { do_request }.to change { User.count }.by(-1)
      end
    end
  end
end
