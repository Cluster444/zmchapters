require 'spec_helper'

describe Coordinator do
  before :each do
    @user = Factory(:user)
  end

  it 'should create a new record with valid attributes' do
    Factory(:coordinator, :user => @user)
  end
  
  describe 'associations' do
    it 'should belong to a user profile' do
      coordinator = Coordinator.new
      coordinator.should respond_to :user
    end

    it 'should belong to a chapter' do
      coordinator = Coordinator.new
      coordinator.should respond_to :chapter
    end
  end
  
  describe 'validations' do
    it 'should require a chapter' do
      coordinator = Factory.build(:coordinator, :chapter => nil)
      coordinator.should_not be_valid
    end

    it 'should require a user' do
      coordinator = Factory.build(:coordinator, :user => nil)
      coordinator.should_not be_valid
    end
  end
end
