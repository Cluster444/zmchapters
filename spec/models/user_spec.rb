require 'spec_helper'

describe User do
  before :each do
    @attr = Factory.attributes_for :user
  end

  it 'should create a new record with valid attributes' do
    User.create! @attr
  end

  it 'should have a geographic location' do
    user = User.new
    user.should respond_to :geographic_location
  end

  it 'should have a chapter' do
    user = User.new
    user.should respond_to :chapter
  end

  it 'should require a name of max length 50' do
    blank_name_user = Factory.build :user, :name => ''
    long_name_user = Factory.build :user, :name => 'a'*51
    blank_name_user.should_not be_valid
    long_name_user.should_not be_valid
  end

  it 'should require a unique username of max length 30' do
    User.create @attr
    blank_username_user = Factory.build :user, :username => ''
    dup_username_user = User.new @attr
    long_username_user = Factory.build :user, :username => 'a'*31
    blank_username_user.should_not be_valid
    dup_username_user.should_not be_valid
    long_username_user.should_not be_valid
  end

  it 'should require an email' do
    blank_email_user = Factory.build :user, :email => ''
    blank_email_user.should_not be_valid
  end

  it 'should have a unique email' do
    user = Factory :user
    dup_email_user = Factory.build :user, :email => user.email
    dup_email_user.should_not be_valid
  end
end
