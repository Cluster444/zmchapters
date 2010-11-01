require 'spec_helper'

describe User do
  
  before :each do
    @chapter = Factory :chapter
    @attr = {
      :name => 'Test Meister',
      :username => 'testmeister',
      :email => 'test@meister.net',
      :password => 'foobarbaz',
      :password_confirmation => 'foobarbaz',
      :chapter_id => @chapter.id
    }
  end
  
  it 'should create a record with valid attributes' do
    User.create! @attr
  end
end
