require 'spec_helper'

describe User do
  let(:user)  { Factory.create(:user)  }
  let(:admin) { Factory.create(:admin) }

  describe 'factories' do
    it { expect { user  }.to change { User.count }.by(1) }
    it { expect { admin }.to change { User.count }.by(1) }
  end
  
  # Associations
  it { should belong_to :chapter }
  it { should have_many :coordinators }

  # Attribute Protection
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :username }
  it { should allow_mass_assignment_of :email }

  it { should_not allow_mass_assignment_of :admin }

  # Validations
  it { should validate_presence_of :name }
  it { should validate_presence_of :username }
  #it { should validate_uniqueness_of :username }
  it { should ensure_length_of(:name).is_at_most(50) }
  it { should ensure_length_of(:username).is_at_most(30) }
  
  # Attribute default state assertions
  it { should_not be_admin }
  it { should_not be_coordinator }
  
  # Behavior
  context 'when admin is set' do
    before  { user.is_admin! }
    subject { user }
    it { should be_admin }
  end

  context 'when admin is unset' do
    before  { admin.is_not_admin! }
    subject { admin }
    it { should_not be_admin }
  end

  context 'when user is assigned as a coordinator' do
    before  { Factory(:coordinator, :user => user) }
    subject { user }
    it { should be_coordinator }
  end

  it 'should provide a name with username' do
    user = Factory.create(:admin)
    user.name_with_username.should == "#{user.name} (#{user.username})"
  end
end
