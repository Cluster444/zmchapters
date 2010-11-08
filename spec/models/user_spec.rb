require 'spec_helper'

describe User do
  before :each do
    @attr = Factory.attributes_for :user
  end

  it 'should create a new record with valid attributes' do
    Factory.create(:user)
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
end
