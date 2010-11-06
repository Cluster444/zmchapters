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

  it 'should have coordinators' do
    chapter = Chapter.new
    chapter.should respond_to :coordinators
  end

  it 'should provide coordinators for the chapter' do
    chapter = Factory :chapter
    c1 = Coordinator.create
    c2 = Coordinator.create
    c1.chapter = chapter
    c2.chapter = chapter
    c1.save; c2.save
    chapter.should have(2).coordinators
  end

  it 'should require a name of max length 50' do
    blank_name_chapter = Chapter.new @attr.merge(:name => '')
    long_name_chapter = Chapter.new @attr.merge(:name => 'a'*51)
    blank_name_chapter.should_not be_valid
    long_name_chapter.should_not be_valid
  end
  
  it 'should require a category' do
    blank_category_chapter = Chapter.new @attr.merge(:category => '')
    blank_category_chapter.should_not be_valid
  end

  it 'should have a valid category' do
    invalid_category_chapter = Chapter.new @attr.merge(:category => :foo)
    invalid_category_chapter.should_not be_valid
  end

  it 'should have the type "Country" if it is associated with a country'
  
  it 'creation should set status to "Pending"' do
    chapter = Chapter.create! @attr.merge(:status => nil)
    chapter.status.should == "pending"
  end

  it 'should reject an invalid status on update' do
    chapter = Factory :chapter
    chapter.status = "invalid_status"
    chapter.should_not be_valid
  end

end
