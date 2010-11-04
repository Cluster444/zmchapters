require 'spec_helper'

describe Chapter do

  before :each do
    @attr = {}
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
    user = chapter.users.create!
    assert user.chapter == chapter
    assert chapter.users.first == user
  end

  it 'should create a user associated with itself and it\'s geographic location' do
    geo = GeographicLocation.create!
    chapter = geo.chapters.create!
    user = chapter.users.create!
    assert user.geographic_location == geo
    assert geo.users.first == user
  end
end
