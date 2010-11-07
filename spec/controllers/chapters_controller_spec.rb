require 'spec_helper'

def do_create
  post :create, :chapter => {:name => "value"}
end

def do_update
  put :update, :id => 1, :chapter => {:name => "value"}
end

describe ChaptersController do

  def mock_chapter(stubs={})
    @mock_chapter ||= mock_model(Chapter, stubs)
  end

  def make_chapters(count=10)
    chapters = []
    count.times do
      chapters << Factory.build(:chapter)
    end
    chapters
  end

  describe "GET index" do
    it 'assigns all chapters as @chapters' do
      chapters = make_chapters
      Chapter.stub(:all).and_return(chapters)
      get :index
      assigns[:chapters].should == chapters
    end
  end
  
  describe "GET show" do
    describe "for a record that exists" do
      it 'should assign @chapter from the id' do
        mock_chapter
        Chapter.stub!(:find).with(1).and_return(@mock_chapter)
        get :show, :id => 1
        assigns[:chapter].should == @mock_chapter
      end
    end

    describe "for a record that doesn't exist" do
      it 'should redirect to the index with a flash error' do
        Chapter.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :show, :id => 1
        response.should redirect_to chapters_url
        flash[:error].should_not be_nil
      end
    end
  end

  describe "GET new" do
    it 'should assign a new chapter to @chapter' do
      chapter = Chapter.new
      Chapter.stub(:new).and_return(chapter)
      get :new
      assigns[:chapter].should == chapter
    end
  end

  describe "GET edit" do
    before :each do
      mock_chapter
    end

    describe "for a record that exists" do
      it 'should assign the chapter for the id to @chapter' do
        Chapter.stub!(:find).with(1).and_return(@mock_chapter)
        get :edit, :id => 1
        assigns[:chapter].should == @mock_chapter
      end
    end

    describe "for a record that does not exist" do
      it 'should redirect to the index with a flash error' do
        Chapter.stub!(:find).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :id => 1
        response.should redirect_to chapters_url
        flash[:error].should_not be_nil
      end
    end
  end

  describe "POST create" do
    before :each do
      mock_chapter
      Chapter.stub!(:new).with("name"=>"value").and_return(@mock_chapter)
      @mock_chapter.stub!(:save!)
    end

    def do_create
      post :create, :chapter => {:name => "value"}
    end

    it 'should assign a new chapter to @chapter using the params' do
      Chapter.should_receive(:new).with("name"=>"value").once.and_return(@mock_chapter)
      do_create
      assigns[:chapter].should == @mock_chapter
    end

    it 'should save the chapter' do
      @mock_chapter.should_receive(:save!)
      do_create
    end

    describe "with valid params" do
      it 'should redirect to show with a flash notice' do
        do_create
        response.should redirect_to chapter_url(@mock_chapter)
        flash[:notice].should_not be_nil
      end
    end

    describe "with invalid params" do
      it 'should render the new template' do
        @mock_chapter.stub!(:save!).and_raise(ActiveRecord::RecordInvalid.new(@mock_chapter))
        do_create
        response.should render_template 'chapters/new'
      end
    end
  end

  describe "PUT update" do
    before :each do 
      mock_chapter
      Chapter.stub!(:find).with(1).and_return(@mock_chapter)
      @mock_chapter.stub!(:update_attributes!).with("name"=>"value")
    end
    
    def do_update
      put :update, :id => 1, :chapter => {:name => "value"}
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
