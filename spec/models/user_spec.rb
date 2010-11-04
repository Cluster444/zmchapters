require 'spec_helper'

describe User do
  before :each do
    @attr = {}
  end

  it 'should create a new record with valid attributes' do
    User.create! @attr
  end

  it 'should have a geographic location' do
    user = User.new
    user.should respond_to :geographic_location
  end

  it 'should have a chapter' do
    user = User.new
    user.should respond_to :chapter
  end
end
