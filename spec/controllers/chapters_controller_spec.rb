require 'spec_helper'

describe ChaptersController do

  def do_create
    geo = Factory(:geo)
    post :create, :chapter => Factory.attributes_for(:chapter, :geographic_location_id => geo.id)
  end

  def do_update
    put :update, :id => 1, :chapter => {:name => "value"}
  end

  def mock_chapter(stubs={})
    @mock_chapter ||= mock_model(Chapter, stubs)
  end

  before :each do
    Chapter.delete_all
    @chapters = (1..3).collect {Factory(:chapter)}
    @chapter = @chapters.first
  end

  describe "GET index" do
    it 'assigns all chapters as @chapters' do
      get :index
      assigns[:chapters].should == @chapters
    end
  end
  
  describe "GET show" do
    describe "for a record that exists" do
      it 'should assign @chapter from the id' do
        get :show, :id => @chapter.id
        assigns[:chapter].should == @chapter
      end
    end

    describe "for a record that doesn't exist" do
      it 'should redirect to the index with a flash error' do
        get :show, :id => @chapters.last.id + 1
        response.should redirect_to chapters_url
        flash[:error].should_not be_nil
      end
    end
  end

  describe "GET new" do
    it 'should assign a new chapter to @chapter' do
      get :new
      assigns[:chapter].should_not be_nil
      assigns[:chapter].should be_new_record
    end
  end

  describe "GET edit" do
    describe "for a record that exists" do
      it 'should assign the chapter for the id to @chapter' do
        get :edit, :id => @chapter.id
        assigns[:chapter].should == @chapter
      end
    end

    describe "for a record that does not exist" do
      it 'should redirect to the index with a flash error' do
        get :edit, :id => @chapters.last.id + 1
        response.should redirect_to chapters_url
        flash[:error].should_not be_nil
      end
    end
  end

  describe "POST create" do
    describe "with invalid params" do
      it 'should render the new template' do
        #post :create
        #response.should render_template 'chapters/new'
      end
    end
  end

  describe "PUT update" do
    before :each do 
      mock_chapter
      Chapter.stub!(:find).with(1).and_return(@mock_chapter)
      @mock_chapter.stub!(:update_attributes!).with("name"=>"value")
    end
    
    describe "for an existing chapter" do
      it 'should assign a chapter from the given id to @chapter' do
        Chapter.should_receive(:find).with(1).once.and_return(@mock_chapter)
        do_update
        assigns[:chapter].should == @mock_chapter
      end

      it 'should update the attributes with those from params' do
        @mock_chapter.should_receive(:update_attributes!)
        do_update
      end

      describe "with valid params" do
        it 'should redirect to the show action for the chapter with a flash notice' do
          do_update
          response.should redirect_to chapter_url(@mock_chapter)
          flash[:notice].should_not be_nil
        end
      end

      describe "with invalid params" do
        it 'should render the edit template' do
          @mock_chapter.stub!(:update_attributes!).and_raise(ActiveRecord::RecordInvalid.new(@mock_chapter))
          do_update
          response.should render_template 'chapters/edit'
        end
      end
    end

    describe "for a non existing chapter" do
      it 'should redirect to the index with a flash error' do
        Chapter.stub!(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
        do_update
        response.should redirect_to chapters_url
        flash[:error].should_not be_nil
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      mock_chapter
      Chapter.stub!(:find).with(1).and_return(@mock_chapter)
      @mock_chapter.stub!(:destroy)
    end

    describe "for an existing chapter" do
      it 'should remove the chapter' do
        @mock_chapter.should_receive(:destroy).once
        delete :destroy, :id => 1
      end

      it 'should redirect to the index with a flash notice' do
        delete :destroy, :id => 1
        response.should redirect_to chapters_url
        flash[:notice].should_not be_nil
      end
    end

    describe "for a non-existing chapter" do
      it 'should redirect to the index with a flash error' do
        Chapter.stub!(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :id => 1
        response.should redirect_to chapters_url
        flash[:error].should_not be_nil
      end
    end
  end
end
