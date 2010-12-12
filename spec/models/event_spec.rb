require 'spec_helper'
require 'shoulda'

describe Event do
  def build(opts={})
    Factory.build(:event, opts)
  end

  it 'should create a record' do
    expect { Factory.create(:event) }.to change { Event.count }.by(1)
  end

  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:starts_at) }
  it { should allow_mass_assignment_of(:ends_at) }

  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_most(255) }
  it { should validate_presence_of :description }
  it { should ensure_length_of(:description).is_at_most(500) }
  it { should validate_presence_of :starts_at }
  it { should validate_presence_of :ends_at }
  
  it 'should have a start in the future' do
    build(:starts_at => (DateTime.now)).should_not be_valid
  end

  it 'should have an end after start' do
    build(:starts_at => (DateTime.now + 2.minutes), :ends_at => (DateTime.now + 1.minute)).should_not be_valid
  end
end
