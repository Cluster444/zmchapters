require 'spec_helper'

describe User do
  before :each do
    @attr = Factory.attributes_for :user
  end

  it 'should create a new record with valid attributes' do
    Factory.create(:user)
  end

  it 'should have a factory for admin creation' do
    Factory.create(:admin).should be_admin
  end

  describe 'associations' do
    it 'should have a geographic location' do
      user = User.new
      user.should respond_to :geographic_location
    end

    it 'should have a chapter' do
      user = User.new
      user.should respond_to :chapter
    end
  end
  
  describe 'validations' do
    it 'should require a name of max length 50' do
      ['','a'*51].each do |bad_name|
        bad_name_user = Factory.build(:user, :name => bad_name)
        bad_name_user.should_not be_valid
      end
    end

    it 'should require a unique username of max length 30' do
      #User.create @attr
      Factory(:user, :username => 'dup_username')
      ['','a'*31,'dup_username'].each do |bad_username|
        bad_username_user = Factory.build(:user, :username => bad_username)
        bad_username_user.should_not be_valid
      end
    end

    it 'should require a unique email' do
      Factory(:user, :email => 'dup@test.com')
      ['','dup@test.com'].each do |bad_email|
        bad_email_user = Factory.build(:user, :email => bad_email)
        bad_email_user.should_not be_valid
      end
    end
  end

  describe 'roles' do
    it 'should not be admin by default' do
      Factory(:user).should_not be_admin
    end
    
    it 'should not allow admin to be set directly' do
      user = Factory(:user)
      user.update_attributes :admin => true
      user.should_not be_admin
    end

    it 'should allow admin to be set' do
      user = Factory(:user)
      user.is_admin!
      user.should be_admin
    end

    it 'should allow admin to be unset' do
      user = Factory(:user)
      user.update_attribute :admin, true
      user.is_not_admin!
      user.should_not be_admin
    end
  end
end
