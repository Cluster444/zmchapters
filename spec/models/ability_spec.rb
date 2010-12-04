require 'spec_helper'
require 'cancan/matchers'

describe 'Ability' do
  def option(key,value)
    Factory(:site_option, :key => key, :value => value)
    @ability = Ability.new(@user)
  end

  describe 'for anyone' do
    before :each do
      @ability = Ability.new(nil)
    end

    it 'should grant read access to Location' do
      @ability.should be_able_to(:read, GeographicLocation)
    end

    it 'should grant read access to Chapter' do
      @ability.should be_able_to(:read, Chapter)
    end

    it 'should grant read access to Page' do
      @ability.should be_able_to(:read, Page)
    end
  end

  describe 'for admin' do
    it 'should grant access to everyting' do
      @admin = Factory(:admin)
      @ability = Ability.new(@admin)
      @ability.should be_able_to(:manage, :all)
    end
  end

  describe 'for members' do
    before :each do
      @user = Factory(:user)
      @ability = Ability.new(@user)
    end

    it 'should deny create access to users' do
      @ability.should_not be_able_to(:create, User)
    end

    it 'should grant update access to the User owned by them' do
      @ability.should be_able_to(:update, @user)
    end

    it 'should deny update access to users not owned by them' do
      @ability.should_not be_able_to(:update, Factory(:user))
    end

    it 'should grant create access to Feedback if it is open' do
      option "feedback_status", "open"
      @ability.should be_able_to(:create, FeedbackRequest)
    end

    it 'should deny create access to Feedback if it is closed' do
      option "feedback_status", "closed"
      @ability.should_not be_able_to(:create, FeedbackRequest)
    end
      
    it 'should grant read access to feedback requests owned by them' do
      @feedback = Factory(:feedback_request, :user_id => @user.id)
      @ability.should be_able_to(:read, @feedback)
    end

    it 'should deny access to feedback not owned by them' do
      @ability.should_not be_able_to(:read, Factory(:feedback_request))
    end
  end
  
  describe 'for the public' do
    before :each do
      @user = nil
      @ability = Ability.new(nil)
    end

    it 'should grant create access to User if registration is open' do
      option "site_registration", "open"
      @ability.should be_able_to(:create, User)
    end

    it 'should deny create access to User if registration is closed' do
      option "site_registration", "closed"
      @ability.should_not be_able_to(:create, User)
    end

    it 'should grant create access to feedback requests if it is public' do
      option "feedback_status", "public"
      @ability.should be_able_to(:create, FeedbackRequest)
    end

    it 'should deny create access to feedback requests if it is closed' do
      option "feedback_status", "closed"
      @ability.should_not be_able_to(:create, FeedbackRequest)
    end
  end
end
