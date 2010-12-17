require 'spec_helper'

describe SiteOption do
  before { Factory.create(:site_option) }

  # Factories
  it { expect { Factory.create(:site_option) }.to change{ SiteOption.count }.by(1) }

  # Mass Assignment
  it { should allow_mass_assignment_of :key }
  it { should allow_mass_assignment_of :value }
  
  it { should_not allow_mass_assignment_of :type }
  it { should_not allow_mass_assignment_of :mutable }
  
  # Validations
  it { should validate_presence_of :key }
  it { should validate_presence_of :value }
  it { should validate_presence_of :type }
  it { should validate_presence_of :mutable }
  
  it { should validate_uniqueness_of :key }

  it { should ensure_length_of(:key).is_at_most(30) }
  it { should ensure_length_of(:value).is_at_most(255) }

  describe 'validations' do
    it 'should accept valid types' do
      ['string','reference','list','set','hash'].each do |valid_type|
        Factory.build(:site_option, :type => valid_type).should be_valid
      end
    end
  end
end
