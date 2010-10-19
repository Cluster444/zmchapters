require 'spec_helper'

describe Country do
  before :each do
    @country = Factory :country
  end

  describe 'relations' do
    it 'should include chapters' do
      @country.should respond_to :chapters
    end

    it 'should have a chapter' do
      @country.chapters.create! :region => 'fubar', :description => 'fubarland'
      @country.chapters.any?
    end
  end
end
