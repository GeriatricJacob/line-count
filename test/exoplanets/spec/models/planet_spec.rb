require 'spec_helper'

describe Planet do
  it { should have_db_column :surface_image }

  it { should validate_presence_of :seed }
  it { should validate_uniqueness_of :seed }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  context 'after creation' do
    specify 'an image should have been generated' do
    end
  end
end
