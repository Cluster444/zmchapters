require 'spec_helper'

describe Chapter do
  
  def create
    Factory.create(:chapter)
  end

  before :all do
    @continent = Factory(:location, :name => "Continent")
    @country   = Factory(:location, :name => "Country")
    @territory = Factory(:location, :name => "Territory")
    @city      = Factory(:location, :name => "City")
    @country.move_to_child_of @continent
    @territory.move_to_child_of @country
    @city.move_to_child_of @territory
  end

  before :each do
    Chapter.delete_all
  end

  it 'should create a new chapter' do
    expect { Factory(:chapter) }.to change { Chapter.count }.by(1)
  end
  
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :category }
  it { should_not allow_mass_assignment_of :status }
  it { should_not allow_mass_assignment_of :geographic_location }
  it { should_not allow_mass_assignment_of :users }
  it { should_not allow_mass_assignment_of :coordinators }
  it { should_not allow_mass_assignment_of :links }
  it { should_not allow_mass_assignment_of :events }

  it { should belong_to :geographic_location }
  it { should have_many :users }
  it { should have_many :coordinators }
  it { should have_many :links }
  it { should have_many :events }

  it { should validate_presence_of :name }
  it { should validate_presence_of :category }
  it { should validate_presence_of :geographic_location }

  it { should ensure_length_of(:name).is_at_most(255) }
  it { should ensure_length_of(:category).is_at_most(255) }
  
  it { should allow_value('pending').for(:status) }
  it { should allow_value('active').for(:status) }
  it { should allow_value('inactive').for(:status) }

  it { should respond_to :location }
  it { should respond_to :is_pending! }
  it { should respond_to :is_active! }
  it { should respond_to :is_inactive! }

  it 'should allow lifecycle status updates' do
    @chapter = Factory(:chapter)
    expect { @chapter.is_active!   }.to change { @chapter.status }.from('pending').to('active')
    expect { @chapter.is_inactive! }.to change { @chapter.status }.from('active').to('inactive')
    expect { @chapter.is_pending!  }.to change { @chapter.status }.from('inactive').to('pending')
  end

  describe 'class methods' do
    subject { Chapter }
    it { should respond_to :find_all_by_location }
  end

  describe 'creation' do
    it 'should set status to "Pending"' do
      chapter = Factory(:chapter)
      chapter.status.should == "pending"
    end
  end

  describe 'custom finders' do
    describe 'by location' do
      def create_location(name, parent=nil)
        l = Factory.create(:location, :name => name)
        l.move_to_child_of(parent) unless parent.nil?
        l
      end

      def create_chapter(location)
        Factory.create(:chapter, :geographic_location => location)
      end
      
      before :each do
        [@continent,@country,@territory,@city].collect do |location|
          create_chapter(location)
        end
      end

      it 'should find chapters within a continent' do
        continent = create_location("Other Continent")
        country   = create_location("Other Country", continent)
        chapters = [create_chapter(country)]
        Chapter.find_all_by_location(continent).should == chapters
      end

      it 'should find chapters within a country' do
        country = create_location("Other Country", @continent)
        territory = create_location("Other Territory", country)
        chapters = [create_chapter(territory)]
        Chapter.find_all_by_location(country).should == chapters
      end

      it 'should find chapters within a territory' do
        territory = create_location("territory", @country)
        city = create_location("city", territory)
        chapters = [create_chapter(city)]
        Chapter.find_all_by_location(territory).should == chapters
      end
    end
  end
end
