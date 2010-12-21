require 'spec_helper'

describe User do
  let(:user)  { Factory.create(:user)  }
  let(:admin) { Factory.create(:admin) }

  #before { Factory.create(:user) }
  
  # Factories
  it { expect { user  }.to change { User.count }.by(1) }
  it { expect { user  }.to_not change { Chapter.count} }
  it { expect { admin }.to change { User.count }.by(1) }
  it { expect { admin }.to_not change { Chapter.count } }
  it { expect { Factory.create(:user_with_chapter) }.to change { User.count }.by(1) }
  it { expect { Factory.create(:user_with_chapter) }.to change { Chapter.count }.by(1) }
  
  # Mass Assignment
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :username }
  it { should allow_mass_assignment_of :email }

  it { should_not allow_mass_assignment_of :admin }
  it { should_not allow_mass_assignment_of :encrypted_password }
  it { should_not allow_mass_assignment_of :password_salt }

  # Associations
  it { should belong_to :chapter }
  it { should have_many :coordinators }
  it { should have_and_belong_to_many :tasks }

  # Validations
  it { should validate_presence_of :name }
  it { should validate_presence_of :username }
  it { should ensure_length_of(:name).is_at_most(50) }
  it { should ensure_length_of(:username).is_at_most(30) }
  
  context do
    before { Factory.create(:user) }
    it { should validate_uniqueness_of :username }
  end
  
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
    before  { Factory(:coordinator_with_chapter, :user => user) }
    subject { user }
    it { should be_coordinator }
  end

  it 'should provide a name with username' do
    user = Factory.create(:admin)
    user.name_with_username.should == "#{user.name} (#{user.username})"
  end
end
