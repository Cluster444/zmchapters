require 'spec_helper'
require 'cancan/matchers'

describe 'Ability' do
  describe 'user' do
    before :each do
     @user = Factory(:user)
     @ability = Ability.new(@user)
    end

    it 'should be able to see geography' do
      @ability.should be_able_to(:read, GeographicLocation.new)
    end

    it 'should be able to see chapters' do
      @ability.should be_able_to(:read, Chapter.new)
    end

    it 'should be able to see users' do
      @ability.should be_able_to(:read, User.new)
    end

    it 'should be able to update own profile' do
      @ability.should be_able_to(:update, @user)
    end

    it 'should not be able to manage chapters' do
      @ability.should_not be_able_to(:manage, Chapter.new)
    end

    it 'should not be able to manage users' do
      @ability.should_not be_able_to(:manage, User.new)
    end
  end
end
