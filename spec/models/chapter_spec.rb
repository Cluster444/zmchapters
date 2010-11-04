require 'spec_helper'

describe Chapter do

  before :each do
    @attr = Factory.attributes_for :chapter
  end

  it 'should create a new record with valid attributes' do
    Chapter.create! @attr
  end

  it 'should have a geographic location' do
    chapter = Chapter.new
    chapter.should respond_to :geographic_location
  end

  it 'should have users' do
    chapter = Chapter.new
    chapter.should respond_to :users
  end

  it 'should create a user associated with itself' do
    chapter = Chapter.create! @attr
    user = chapter.users.create! Factory.attributes_for :user
    assert user.chapter == chapter
    assert chapter.users.first == user
  end

  it 'should create a user associated with itself and it\'s geographic location' do
    geo = GeographicLocation.create! Factory.attributes_for :geo
    chapter = geo.chapters.create! @attr
    user = chapter.users.create! Factory.attributes_for :user
    assert user.geographic_location == geo
    assert geo.users.first == user
  end
end
