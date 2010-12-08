require 'spec_helper'

describe GeographicLocation do
  
  it 'is deprecated' do
    assert false, 'rename to Location'
  end

  before :each do
    GeographicLocation.delete_all
  end
  
  def create(name=nil, opts={})
    opts.merge(:name => name) unless name.nil?
    Factory.create(:location, opts)
  end
  
  def build(opts={})
    Factory.build(:location, opts)
  end

  def make_geo_set
    @continent = create("Continent")
    @country   = create("Country")
    @territory = create("Territory")
    @city      = create("City")
    @country.move_to_child_of(@continent)
    @territory.move_to_child_of(@country)
    @city.move_to_child_of(@territory)
  end

  it 'should create a new record with valid attributes' do
    Factory.create(:location)
  end

  it 'should tell whether coordinate information is needed' do
    location = create("Test")
    location.need_coordinates?.should be_false
    location.update_attribute :lat, nil
    location.update_attribute :lng, nil
    location.update_attribute :zoom, nil
    location.need_coordinates?.should be_true
  end

  it 'should provide a hash of map information for a location' do
    map = create.map_hash
    map.should have_key(:lat)
    map.should have_key(:lng)
    map.should have_key(:zoom)
    map.should have_key(:markers)
    map.should have_key(:events)
  end

  it 'should provide a hash of default map information' do
    map = GeographicLocation.map_hash
    map.should have_key(:lat)
    map.should have_key(:lng)
    map.should have_key(:zoom)
    map.should have_key(:markers)
    map.should have_key(:events)
  end
  
  describe 'associations' do
    it 'should have chapters' do
      geo = GeographicLocation.new @attr
      geo.should respond_to :chapters
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
  end

  describe 'validations' do
    it 'should require a name of max length 255' do
      ['','a'*256].each { |bad_name| build(:name => bad_name).should_not be_valid }
    end

    it 'should require latitude' do
      [''].each { |bad_lat| build(:lat => bad_lat).should_not be_valid }
    end

    it 'should require longtitude' do
      [''].each { |bad_lng| build(:lng => bad_lng).should_not be_valid }
    end

    it 'should require zoom' do
      [''].each { |bad_zoom| build(:zoom => bad_zoom).should_not be_valid }
    end
  end
  
  describe 'scopes' do
    before :each do
      make_geo_set
    end

    it 'should provide a list of continents' do
      GeographicLocation.continents.should == [@continent]
    end

    it 'should provide a list of countries' do
      GeographicLocation.countries.should == [@country]
    end
        
    it 'should provide a list of territories' do
      GeographicLocation.territories.should == [@territory]
    end
  end

  describe "type queries" do
    before :each do
      make_geo_set
    end

    it 'should tell if the location is a continent' do
      @continent.is_continent?.should be_true
      @continent.is_country?.should be_false
      @continent.is_territory?.should be_false
      @continent.is_subterritory?.should be_false
    end

    it 'should tell if the location is a country' do
      @country.is_continent?.should be_false
      @country.is_country?.should be_true
      @country.is_territory?.should be_false
      @country.is_subterritory?.should be_false
    end

    it 'should tell if the location is a territory' do
      @territory.is_continent?.should be_false
      @territory.is_country?.should be_false
      @territory.is_territory?.should be_true
      @territory.is_subterritory?.should be_false
    end

    it 'should tell if the location is a subterritory' do
      @city.is_continent?.should be_false
      @city.is_country?.should be_false
      @city.is_territory?.should be_false
      @city.is_subterritory?.should be_true
    end
  end

  describe "formatted output" do
    before :each do
      make_geo_set
    end
    
    it 'is deprecated' do
      assert false, "merge this into a helper"
    end

    it 'should provide a name with ancestors for state' do
      @territory.self_and_ancestors_name.should == "#{@territory.name}, #{@country.name}, #{@continent.name}"
    end

    it 'should provide a name with ancestors for country' do
      @country.self_and_ancestors_name.should == "#{@country.name}, #{@continent.name}"
    end

    it 'should provide a name with ancestors for continent' do
      @continent.self_and_ancestors_name.should == "#{@continent.name}"
    end

    it 'should provide aname with parent for territory' do
      @territory.self_and_parent_name.should == "#{@territory.name}, #{@country.name}"
    end

    it 'should provide a name with parent for country' do
      @country.self_and_parent_name.should == "#{@country.name}, #{@continent.name}"
    end

    it 'should provide a name with parent for continent' do
      @continent.self_and_parent_name.should == "#{@continent.name}"
    end
  end
end
