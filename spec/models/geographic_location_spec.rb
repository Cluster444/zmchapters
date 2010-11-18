require 'spec_helper'

describe GeographicLocation do
  
  before :each do
    @attr = Factory.attributes_for :geo
  end

  after :each do
    GeographicLocation.delete_all
  end

  def geo(name)
    Factory(:geo, :name => name)
  end

  def make_geo_set
    earth = geo("Earth")
    
    na = geo("North America")
    eu = geo("Europe")
    na.move_to_child_of earth
    eu.move_to_child_of earth
    
    canada = geo("Canada")
    usa = geo("USA")
    germany = geo("Germany")
    finland = geo("Finland")

    canada.move_to_child_of na
    usa.move_to_child_of na
    germany.move_to_child_of eu
    finland.move_to_child_of eu

    [canada,usa,germany,finland].each do |country|
      ('A'..'C').each {|t| geo(t).move_to_child_of country}
    end

    earth
  end

  it 'should create a new record with valid attributes' do
    GeographicLocation.create! @attr
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
      ['','a'*256].each do |bad_name|
        bad_name_geo = Factory.build(:geo, :name => bad_name)
        bad_name_geo.should_not be_valid
      end
    end
  end
  
  describe 'geo set operations' do
    before :each do
      make_geo_set
    end

    it 'should provide a list of continents' do
      #GeographicLocation.roots.each {|r| puts r.name}
      GeographicLocation.roots.last.children.should == GeographicLocation.continents
    end

    it 'should provide a list of countries' do
      countries = []
      GeographicLocation.continents.each do |continent|
        continent.children.each {|country| countries << country}
      end
      countries.should == GeographicLocation.countries
    end
        
    it 'should provide a list of territories' do
      territories = []
      GeographicLocation.countries.each do |country|
        country.children.each {|territory| territories << territory}
      end
      territories.should == GeographicLocation.territories
    end

    it 'should find countries with chapters' do
      country = GeographicLocation.countries.first
      Factory(:chapter, :geographic_location => country)
      GeographicLocation.countries_with_chapters.should == [country]
    end
  end

  describe "formatted output" do
    before :each do
      earth = Factory(:geo, :name => "Earth")
      @continent = Factory(:geo, :name => "Continent")
      @country = Factory(:geo, :name => "Country")
      @state = Factory(:geo, :name => "State")
      @continent.move_to_child_of earth
      @country.move_to_child_of @continent
      @state.move_to_child_of @country
    end

    it 'should provide a name with ancestors for state' do
      @state.self_and_ancestors_name.should == "#{@state.name}, #{@country.name}, #{@continent.name}"
    end

    it 'should provide a name with ancestors for country' do
      @country.self_and_ancestors_name.should == "#{@country.name}, #{@continent.name}"
    end

    it 'should provide a name with ancestors for continent' do
      @continent.self_and_ancestors_name.should == "#{@continent.name}"
    end

    it 'should provide aname with parent for territory' do
      @state.self_and_parent_name.should == "#{@state.name}, #{@country.name}"
    end

    it 'should provide a name with parent for country' do
      @country.self_and_parent_name.should == "#{@country.name}, #{@continent.name}"
    end

    it 'should provide a name with parent for continent' do
      @continent.self_and_parent_name.should == "#{@continent.name}"
    end
  end
end
