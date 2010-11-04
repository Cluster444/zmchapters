require 'spec_helper'

describe GeographicLocation do
  
  before :each do
    @attr = Factory.attributes_for :geo
  end

  it 'should create a new record with valid attributes' do
    GeographicLocation.create! @attr
  end

  it 'should have chapters' do
    geo = GeographicLocation.new @attr
    geo.should respond_to :chapters
  end

  it 'should create a chapter associated with itself' do
    geo = GeographicLocation.create! @attr
    chapter = geo.chapters.create! Factory.attributes_for :chapter
    assert chapter.geographic_location == geo
    assert geo.chapters.first == chapter
  end

  it 'should be a nested set' do
    geo = GeographicLocation.new
    geo.should respond_to :parent
    geo.should respond_to :children
    geo.should respond_to :depth
  end

  it 'should have users' do
    geo = GeographicLocation.new
    geo.should respond_to :users
  end

  it 'should create a user associated with itself' do
    geo = GeographicLocation.create! @attr
    user = geo.users.create! Factory.attributes_for :user
    assert user.geographic_location == geo
    assert geo.users.first == user
  end
end
