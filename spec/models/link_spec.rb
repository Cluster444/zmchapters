require 'spec_helper'

describe Link do
  # Factories
  it { expect { Factory.create(:link) }.to change { Link.count }.by(1) }
  
  # Mass Assignment
  it { should allow_mass_assignment_of :url }
  it { should allow_mass_assignment_of :title }
  it { should allow_mass_assignment_of :linkable }
  it { should_not allow_mass_assignment_of :linkable_type }
  it { should_not allow_mass_assignment_of :linkable_id }

  # Associations
  it { should belong_to :linkable }

  # Validations
  it { should validate_presence_of :url }
  it { should validate_presence_of :title }
  it { should validate_presence_of :linkable }

  it { should ensure_length_of(:url).is_at_most(255) }
  it { should ensure_length_of(:title).is_at_most(255) }

end
