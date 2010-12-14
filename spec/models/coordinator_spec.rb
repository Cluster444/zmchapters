require 'spec_helper'

describe Coordinator do
  let (:coordinator) { Factory.create(:coordinator) }

  context 'factories' do
    it { expect { coordinator }.to change { Coordinator.count }.by(1) }
    it { expect { coordinator }.to change { Chapter.count }.by(1) }
    it { expect { coordinator }.to change { User.count }.by(1) }
    it { expect { Factory(:coordinator_with_chapter) }.to change { Coordinator.count }.by(1) }
    it { expect { Factory(:coordinator_with_chapter) }.to change { Chapter.count }.by(1) }
    it { expect { Factory(:coordinator_with_chapter) }.to change { User.count }.by(1) }
  end

  # Associations
  it { should belong_to :chapter }
  it { should belong_to :user }

  # Mass Assignment
  it { should allow_mass_assignment_of :user }
  it { should allow_mass_assignment_of :chapter }

  it { should_not allow_mass_assignment_of :user_id }
  it { should_not allow_mass_assignment_of :chapter_id }

  # Validatons
  it { should validate_presence_of :user }
  it { should validate_presence_of :chapter }
  
  context 'when no chapter is given' do
    subject { Coordinator.new :user => Factory(:user_with_chapter) }
    it("should associate with the user's chapter" ) { should be_valid }
  end
end
