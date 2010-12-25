require 'spec_helper'

describe Feedback do
  # Factories
  it { expect { Factory.create(:feedback) }.to change { Feedback.count }.by(1) }
  
  # Mass Assignment
  it { should allow_mass_assignment_of :email }
  it { should allow_mass_assignment_of :subject }
  it { should allow_mass_assignment_of :message }
  it { should allow_mass_assignment_of :category }

  it { should_not allow_mass_assignment_of :user_id }

  # Associations
  it { should belong_to :user }

  # Validations
  it { should validate_presence_of :email }
  it { should validate_presence_of :subject }
  it { should validate_presence_of :message }
  it { should validate_presence_of :category }

  it { should ensure_length_of(:email).is_at_most(255) }
  it { should ensure_length_of(:subject).is_at_most(255) }
  it { should ensure_length_of(:message).is_at_most(4096) }
  
  it { should allow_value('bug').for(:category) }
  it { should allow_value('feature').for(:category) }

  context 'validation with a user' do
    subject { Factory.build(:feedback, :user => mock_model(User), :email => nil) }
    it { should be_valid }
  end
end
