require 'spec_helper'

describe Chapter do
  
  before :all do
    @continent = Factory(:geo, :name => "Continent")
    @country   = Factory(:geo, :name => "Country")
    @territory = Factory(:geo, :name => "Territory")
    @city      = Factory(:geo, :name => "City")
    @country.move_to_child_of @continent
    @territory.move_to_child_of @country
    @city.move_to_child_of @territory
  end

  before :each do
    Chapter.delete_all
  end

  it 'should create a new record with valid attributes' do
    Factory(:chapter)
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
      ['','a'*101].each do |bad_name|
        bad_name_chapter = Factory.build(:chapter, :name => bad_name)
        bad_name_chapter.should_not be_valid
      end
    end
    
    it 'should require a category' do
      blank_category_chapter = Factory.build(:chapter, :category => '')
      blank_category_chapter.should_not be_valid
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

  describe "index" do
    before :each do
      @chapters = 5.times.collect { Factory(:chapter, :geographic_location => @city, :category => 'city') }
    end

    it 'should provide all of the records with no filters' do
      Chapter.index.should == @chapters
    end

    it 'should limit based on a per_page param' do
      Chapter.index(:per_page => 2).should == @chapters[0..1]
    end

    it 'should offset based on a page param' do
      Chapter.index(:per_page => 2, :page => 2).should == @chapters[2..3]
    end

    it 'should filter by a search param' do
      chapters = ["This City","That City"].collect { |name| Factory(:chapter, :name => name) }
      Chapter.index(:search => "city").should == chapters
    end
    
    describe 'when sorting' do
      it 'on name asc' do
        chapters = ["A","B"].collect { |name| Factory(:chapter, :name => name) }
        Chapter.index(:sort => 'name', :direction => 'asc')[0..1].should == chapters
      end

      it 'on name desc' do
        chapters = ["Z","Y"].collect { |name| Factory(:chapter, :name => name) }
        Chapter.index(:sort => 'name', :direction => 'desc')[0..1].should == chapters
      end

      it 'on member count asc'
      it 'on member count desc'
      it 'on coordinator count asc'
      it 'on coordinator count desc'
    end
  end
end
