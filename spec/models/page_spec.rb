require 'spec_helper'

describe Page do
  
  # Factories
  it { expect { Factory.create(:page) }.to change { Page.count }.by(1) }

  # Mass Assignment
  it { should allow_mass_assignment_of :title }
  it { should allow_mass_assignment_of :content }
  it { should_not allow_mass_assignment_of :uri }

  # Validations
  it { should validate_presence_of :uri }
  it { should validate_presence_of :title }
  it { should validate_presence_of :content }
  
  it { should ensure_length_of(:uri).is_at_most(100) }
  it { should ensure_length_of(:title).is_at_most(255) }
  it { should ensure_length_of(:content).is_at_most(8192) }
end
