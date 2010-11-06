require 'spec_helper'

describe ChaptersController do
  
  describe "GET index" do
    before :each do
      @chapter = Factory.build :chapter
      Chapter.stub(:paginate).and_return(@chapter)
    end

    it 'should be successful' do
      get :index
      response.should be_success
    end

    it 'should paginate' do
      Chapter.should_receive(:paginate).once.with(:page => 1)
      get :index, :page => 1
    end
  end
  
  describe "GET show" do
    before :each do
      @chapter = Factory.build :chapter
      @chapter.id = 1
      Chapter.stub!(:find).and_return(@chapter)
    end

    it 'should be successful' do
      get :show, :id => @chapter.id
      response.should be_success
    end

    it 'should look for a record with the given id' do
      chapter = Factory.build :chapter
      chapter.id = 2
      Chapter.should_receive(:find).with(chapter.id).once.and_return(chapter)
      get :show, :id => chapter.id
    end

    it 'should render edit with a valid result' do
      get :show, :id => @chapter.id
      response.should render_template 'chapters/show'
    end

    it 'should be not found if find returns nil' do
      Chapter.stub!(:find).with(anything()).and_return(nil)
      get :show, :id => 1
      response.should be_not_found
    end
  end
end
