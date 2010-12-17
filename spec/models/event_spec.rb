require 'spec_helper'
require 'shoulda'

describe Event do
  def build(opts={})
    Factory.build(:event, opts)
  end
  
  describe 'factories' do
    it { expect { Factory.create(:event)         }.to change { Event.count }.by(1) }
    it { expect { Factory.create(:chapter_event) }.to change { Event.count }.by(1) }
    it { expect { Factory.create(:user_event)    }.to change { Event.count }.by(1) }
  end
  
  # Attribute Accessibility
  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:starts_at) }
  it { should allow_mass_assignment_of(:ends_at) }
  it { should_not allow_mass_assignment_of(:plannable) }

  # Associations
  it { should belong_to :plannable }

  #Validations
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :starts_at }
  it { should validate_presence_of :ends_at }
  it { should ensure_length_of(:title).is_at_most(255) }
  it { should ensure_length_of(:description).is_at_most(500) }
  
  it 'should have a start in the future' do
    build(:starts_at => (DateTime.now)).should_not be_valid
  end

  it 'should have an end after start' do
    starts_at = DateTime.now + 2.minutes
    ends_at   = starts_at - 1.minute
    build(:starts_at => starts_at, :ends_at => ends_at).should_not be_valid
  end
end
