require 'spec_helper'

module LocationMatchers
  extend RSpec::Matchers::DSL

  matcher(:be_continent)    { match { |location| location.is_continentalal? } }
  matcher(:be_nation)      { match { |location| location.is_national? } }
  matcher(:be_region)       { match { |location| location.is_regional? } }
  matcher(:be_local)        { match { |location| location.is_local? } }
end

describe Location do
  include LocationMatchers
  
  it 'is deprecated' do
    #assert true, 'rename to Location'
  end

  before :each do
    Location.delete_all
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
    @nation   = create("Country")
    @region = create("Territory")
    @local      = create("City")
    @nation.move_to_child_of(@continent)
    @region.move_to_child_of(@nation)
    @local.move_to_child_of(@region)
  end
  
  # Factories
  it { expect { Factory.create(:location) }.to change { Location.count }.by(1) }

  # Mass Assignment
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :lng }
  it { should allow_mass_assignment_of :lat }
  it { should allow_mass_assignment_of :zoom }

  # Assocation
  it { should have_many :children }
  it { should belong_to :parent }
  it { should belong_to :locatable }

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
    map = Location.map_hash
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

    subject { Location }
    its(:continents) { should == [@continent] }
    its(:nations)    { should == [@nation] }
    its(:regions)    { should == [@region] }
    its(:locals)     { should == [@local] }
  end

  describe "type queries" do
    before :each do
      make_geo_set
    end
    
    it 'should tell if the location is a continent' do
      @continent.is_continental?.should be_true
      @continent.is_national?.should be_false
      @continent.is_regional?.should be_false
      @continent.is_local?.should be_false
    end

    it 'should tell if the location is a nation' do
      @nation.is_continental?.should be_false
      @nation.is_national?.should be_true
      @nation.is_regional?.should be_false
      @nation.is_local?.should be_false
    end

    it 'should tell if the location is a region' do
      @region.is_continental?.should be_false
      @region.is_national?.should be_false
      @region.is_regional?.should be_true
      @region.is_local?.should be_false
    end

    it 'should tell if the location is a subregion' do
      @local.is_continental?.should be_false
      @local.is_national?.should be_false
      @local.is_regional?.should be_false
      @local.is_local?.should be_true
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
      @region.self_and_ancestors_name.should == "#{@region.name}, #{@nation.name}, #{@continent.name}"
    end

    it 'should provide a name with ancestors for nation' do
      @nation.self_and_ancestors_name.should == "#{@nation.name}, #{@continent.name}"
    end

    it 'should provide a name with ancestors for continent' do
      @continent.self_and_ancestors_name.should == "#{@continent.name}"
    end

    it 'should provide aname with parent for region' do
      @region.self_and_parent_name.should == "#{@region.name}, #{@nation.name}"
    end

    it 'should provide a name with parent for nation' do
      @nation.self_and_parent_name.should == "#{@nation.name}, #{@continent.name}"
    end

    it 'should provide a name with parent for continent' do
      @continent.self_and_parent_name.should == "#{@continent.name}"
    end
  end
end
