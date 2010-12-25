require 'spec_helper'

module TaskMatchers
  extend RSpec::Matchers::DSL
  
  matcher :have_state do |state|
    match do |task|
      Task.respond_to?("find_#{state}") and
      Task.valid_states.include?(state.to_s)
    end
  end
end

describe Task do
  include TaskMatchers

  let(:task) { Factory(:task) }

  # Factories
  it { expect { Factory(:task) }.to change { Task.count }.by(1) }

  # Mass Assignment
  it { should allow_mass_assignment_of :status }
  it { should allow_mass_assignment_of :priority }
  it { should allow_mass_assignment_of :category }
  it { should allow_mass_assignment_of :subject }
  it { should allow_mass_assignment_of :description }
  it { should allow_mass_assignment_of :starts_at }
  it { should allow_mass_assignment_of :due_at }
  it { should allow_mass_assignment_of :percent_complete }
  it { should_not allow_mass_assignment_of :taskable_type }
  it { should_not allow_mass_assignment_of :taskable_id }

  # Associations
  it { should belong_to :taskable }
  it { should have_and_belong_to_many :users }

  # Validations
  it { should validate_presence_of :status }
  it { should validate_presence_of :priority }
  it { should validate_presence_of :category }
  it { should validate_presence_of :subject }
  it { should validate_presence_of :description }
  it { should validate_presence_of :starts_at }
  it { should validate_presence_of :percent_complete }
  it { should validate_presence_of :taskable }

  it { should ensure_length_of(:category).is_at_most(255) }
  it { should ensure_length_of(:subject).is_at_most(255) }
  it { should ensure_length_of(:description).is_at_most(4096) }

  it { should ensure_inclusion_of(:percent_complete).in_range(0..100) }
  
  # Lifecycle
  it { should_not allow_value('foo').for(:status) }
  %w(new in_progress resolved closed rejected).each do |state|
    it { should allow_value(state).for(:status) }
    it { should have_state state }
  end

  # Priority
  it { should_not allow_value('foo').for(:priority) }
  %w(low normal high urgent).each do |priority|
    it { should allow_value(priority).for(:priority) }
  end
end
