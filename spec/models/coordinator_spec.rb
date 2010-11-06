require 'spec_helper'

describe Coordinator do
  before :each do
    @attr = Factory.attributes_for :coordinator
  end

  it 'should create a new record with valid attributes' do
    Coordinator.create! @attr
  end

  it 'should belong to a user profile' do
    coordinator = Coordinator.new
    coordinator.should respond_to :user
  end

  it 'should belong to a chapter' do
    coordinator = Coordinator.new
    coordinator.should respond_to :chapter
  end

  it 'should allow user and chapter to be set' do
    coordinator = Coordinator.create!
    user = Factory :user
    chapter = Factory :chapter
    coordinator.user = user
    coordinator.chapter = chapter
    coordinator.save!
    assert Coordinator.first.user == user
    assert Coordinator.first.chapter == chapter
  end
end
