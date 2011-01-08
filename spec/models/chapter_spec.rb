require 'spec_helper'

describe Chapter do
  let(:chapter) { Factory.create(:chapter) }

  before :each do
    Chapter.delete_all
  end

  it 'should create a new chapter' do
    expect { Factory.create(:chapter) }.to change { Chapter.count }.by(1)
  end
  
  it { should allow_mass_assignment_of :name }
  it { should_not allow_mass_assignment_of :status }
  it { should_not allow_mass_assignment_of :location }
  it { should_not allow_mass_assignment_of :users }
  it { should_not allow_mass_assignment_of :coordinators }
  it { should_not allow_mass_assignment_of :links }
  it { should_not allow_mass_assignment_of :events }

  it { should have_many :members }
  it { should have_many :coordinators }
  it { should have_many :links }
  it { should have_many :events }
  it { should have_one :location }

  it { should ensure_length_of(:name).is_at_most(255) }
  
  it { should allow_value('pending').for(:status) }
  it { should allow_value('active').for(:status) }
  it { should allow_value('inactive').for(:status) }

  it { should respond_to :location }
  it { should respond_to :is_pending! }
  it { should respond_to :is_active! }
  it { should respond_to :is_inactive! }

  it 'should allow lifecycle status updates' do
    expect { chapter.is_active!   }.to change { chapter.status }.from('pending').to('active')
    expect { chapter.is_inactive! }.to change { chapter.status }.from('active').to('inactive')
    expect { chapter.is_pending!  }.to change { chapter.status }.from('inactive').to('pending')
  end

  describe 'creation' do
    it 'should set status to "Pending"' do
      chapter = Factory(:chapter)
      chapter.status.should == "pending"
    end
  end
end
