require 'spec_helper'

describe Member do
  
  before :each do
    @chapter = Factory :chapter
    @attr = {
      :name => 'Test Meister',
      :alias => 'testmeister',
      :email => 'test@meister.net',
      :password => 'foobarbaz',
      :password_confirmation => 'foobarbaz',
      :chapter_id => @chapter.id
    }
  end
  
  it 'should create a record with valid attributes' do
    Member.create! @attr
  end
end
