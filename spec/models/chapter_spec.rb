require 'spec_helper'

describe Chapter do
  before :each do
    @attr = {
      :title => 'test',
      :description => 'test',
      :language => 'English'
    }
  end
  
  it 'should create a record with valid attributes' do
    Chapter.create! @attr
  end
end
