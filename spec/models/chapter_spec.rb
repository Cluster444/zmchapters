require 'spec_helper'

describe Chapter do

  before :each do
    @attr = Factory.attributes_for :chapter
  end

  it 'should create a new record with valid attributes' do
    Factory :chapter
  end
  
  describe 'associations' do
    it 'should have a geographic location' do
      chapter = Chapter.new
      chapter.should respond_to :geographic_location
    end

    it 'should have users' do
      chapter = Chapter.new
      chapter.should respond_to :users
    end

    it 'should have coordinators' do
      chapter = Chapter.new
      chapter.should respond_to :coordinators
    end
  end

  describe 'validations' do
    it 'should require a name of max length 50' do
      ['','a'*51].each do |bad_name|
        bad_name_chapter = Factory.build(:chapter, :name => bad_name)
        bad_name_chapter.should_not be_valid
      end
    end
    
    it 'should require a category' do
      blank_category_chapter = Factory.build(:chapter, :category => '')
      blank_category_chapter.should_not be_valid
    end

    it 'should have a valid category' do
      invalid_category_chapter = Factory.build(:chapter, :category => '!!invalid!!')
      invalid_category_chapter.should_not be_valid
    end

    it 'should reject an invalid status on update' do
      chapter = Factory(:chapter)
      chapter.status = "invalid_status"
      chapter.should_not be_valid
    end

    it 'should require a geographic location' do
      chapter = Factory.build(:chapter, :geographic_location => nil)
      chapter.should_not be_valid
    end
  end

  describe 'creation' do
    it 'should set status to "Pending"' do
      chapter = Factory(:chapter)
      chapter.status.should == "pending"
    end
  end
end
