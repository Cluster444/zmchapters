require 'spec_helper'

describe SiteOption do
  
  it 'should have a site option factory' do
    Factory.create(:site_option)
  end

  describe 'validations' do
    it 'should reject invalid keys' do
      Factory.create(:site_option, :key => 'dup_key')
      ['','a'*31,'dup_key'].each do |invalid_key|
        Factory.build(:site_option, :key => invalid_key).should_not be_valid
      end
    end

    it 'should accept valid keys' do
      Factory.build(:site_option, :key => 'valid_key').should be_valid
    end

    it 'should reject invalid types' do
      ['','invalid_type'].each do |invalid_type|
        Factory.build(:site_option, :type => invalid_type).should_not be_valid
      end
    end

    it 'should accept valid types' do
      ['string','reference','list','set','hash'].each do |valid_type|
        Factory.build(:site_option, :type => valid_type).should be_valid
      end
    end

    it 'should reject invalid values' do
      ['','a'*256].each do |invalid_value|
        Factory.build(:site_option, :value => invalid_value).should_not be_valid
      end
    end
  end
end
