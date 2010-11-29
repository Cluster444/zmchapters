require 'spec_helper'
require 'cancan/matchers'

describe 'Ability' do
  describe 'anonymous' do
    before :each do
      @ability = Ability.new(nil)
    end
  end

  describe 'user' do
    before :each do
     @user = Factory(:user)
     @ability = Ability.new(@user)
    end

    it 'should be able to read geography' do
      @ability.should be_able_to(:read, GeographicLocation.new)
    end

    it 'should not be able to mutate geography' do
      @ability.should_not be_able_to(:create, GeographicLocation)
      @ability.should_not be_able_to(:update, GeographicLocation)
      @ability.should_not be_able_to(:destroy, GeographicLocation)
    end

    it 'should be able to read chapters' do
      @ability.should be_able_to(:read, Chapter.new)
    end

    it 'should not be able to mutate chapters' do
      @ability.should_not be_able_to(:create, Chapter)
      @ability.should_not be_able_to(:update, Chapter)
      @ability.should_not be_able_to(:destroy, Chapter)
    end

    it 'should be able to see users' do
      @ability.should be_able_to(:read, User.new)
    end

    it 'should be able to update own users' do
      @ability.should be_able_to(:update, @user)
    end

    it 'should not be able to mutate other users' do
      @ability.should_not be_able_to(:update, User)
      @ability.should_not be_able_to(:create, User)
      @ability.should_not be_able_to(:destroy, User)
    end
    
    it 'should be able to read chapters' do
      @ability.should be_able_to(:read, Chapter)
    end

    it 'should not be able to manage chapters' do
      @ability.should_not be_able_to(:update, Chapter)
      @ability.should_not be_able_to(:create, Chapter)
      @ability.should_not be_able_to(:destroy, Chapter)
    end

    it 'should be able to read pages' do
      @ability.should be_able_to(:read, Page)
    end

    it 'should not be able to mutate pages' do
      @ability.should_not be_able_to(:update, Page)
      @ability.should_not be_able_to(:create, Page)
      @ability.should_not be_able_to(:destroy, Page)
    end

    it 'should not be able to access site options' do
      @ability.should_not be_able_to(:read, SiteOption)
      @ability.should_not be_able_to(:update, SiteOption)
      @ability.should_not be_able_to(:create, SiteOption)
      @ability.should_not be_able_to(:destroy, SiteOption)
    end
    
    it 'should be able to read own feedback'
    it 'should not be able to read other users feedback'

    it 'should be able to create feedback' do
      @ability.should be_able_to(:create, FeedbackRequest)
    end
    
    it 'should not be able to modify existing feedback' do
      @ability.should_not be_able_to(:update, FeedbackRequest)
      @ability.should_not be_able_to(:destroy, FeedbackRequest)
    end
  end
end
