require 'spec_helper'

describe ChaptersController do
  before :each do
    @chapter = Factory :chapter
    @country = Factory :country
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'index_country'" do
    it "should be successful with a name" do
      get 'index_country', :name => @country.name
      response.should be_success
    end

    it "should be successful with an id" do
      get 'index_country', :id => @country
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => @chapter
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @chapter
      response.should be_success
    end
  end

end
