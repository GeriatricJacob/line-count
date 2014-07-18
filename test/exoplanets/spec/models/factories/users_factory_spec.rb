require 'spec_helper'

describe 'users factory' do
  subject { create :user }

  it_should 'return a valid instance'
end

describe 'admins factory' do
  subject { create :admin }

  it_should 'return a valid instance'

  it 'should have admin role' do
    subject.has_role?(:admin).should be_true
  end
end
