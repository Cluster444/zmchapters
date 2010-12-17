require 'spec_helper'

module LocationMatchers
  extend RSpec::Matchers::DSL

  matcher(:be_continent)    { match { |location| location.is_continent? } }
  matcher(:be_country)      { match { |location| location.is_country? } }
  matcher(:be_territory)    { match { |location| location.is_territory? } }
  matcher(:be_subterritory) { match { |location| location.is_territory? } }
end

describe GeographicLocation do
  include LocationMatchers
  
  it 'is deprecated' do
    #assert true, 'rename to Location'
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
  
  # Factories
  it { expect { Factory.create(:location) }.to change { GeographicLocation.count }.by(1) }

  # Mass Assignment
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :lng }
  it { should allow_mass_assignment_of :lat }
  it { should allow_mass_assignment_of :zoom }

  # Assocation
  it { should have_many :users }
  it { should have_many :chapters }
  it { should have_many :children }
  it { should belong_to :parent }

  # Validations
  it { should validate_presence_of :name }
  it { should validate_presence_of :lng }
  it { should validate_presence_of :lat }
  it { should validate_presence_of :zoom }
  it { should ensure_length_of(:name).is_at_most(255) }

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
  
  describe 'scopes' do
    before :each do
      make_geo_set
    end

    subject { GeographicLocation }
    its(:continents)     { should == [@continent] }
    its(:countries)      { should == [@country] }
    its(:territories)    { should == [@territory] }
    its(:subterritories) { should == [@city] }
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
      #assert false, "merge this into a helper"
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
