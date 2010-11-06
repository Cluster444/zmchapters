require 'spec_helper'

def do_create
  post :create, :chapter => {:name => "value"}
end

def do_update
  put :update, :id => 1, :chapter => {:name => "value"}
end

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

  describe "GET new" do
    it 'should be successful' do
      get :new
      response.should be_success
    end

    it 'should create a new Chapter' do
      Chapter.should_receive(:new).once
      get :new
    end
  end

  describe "GET edit" do
    it 'should be successful' do
      Chapter.stub!(:find).with(1).and_return(Factory.build :chapter)
      get :edit, :id => 1
      response.should be_success
    end

    it 'should look for a record with the given id' do
      Chapter.should_receive(:find).with(1).once.and_return(Factory.build :chapter)
      get :edit, :id => 1
    end

    it 'should be not found if find returns nil' do
      Chapter.stub!(:find).with(1).and_return(nil)
      get :edit, :id => 1
      response.should be_not_found
    end
  end

  describe "POST create" do
    describe "with a valid chapter" do

      before :each do
        @chapter = mock_model(Chapter, :save! => true)
        Chapter.stub!(:new).and_return(@chapter)
      end

      it 'should be redirect' do
        do_create
        response.should be_redirect
      end

      it 'should create the chapter' do
        Chapter.should_receive(:new).with("name"=>"value").and_return(@chapter)
        do_create
      end

      it 'should save the chapter' do
        @chapter.should_receive(:save!).and_return(true)
        do_create
      end

      it 'should assign chapter' do
        do_create
        assigns(:chapter).should == @chapter
      end

      it 'should redirct to the chapter index' do
        do_create
        response.should redirect_to(chapters_url)
      end

      it 'should flash a notice saying the chapter was created' do
        do_create
        flash[:notice].should =~ /chapter created/i
      end

    end

    describe 'with an invalid chapter' do
      
      before :each do
        @chapter = mock_model(Chapter)
        @chapter.stub!(:save!).and_raise(ActiveRecord::RecordInvalid.new(@chapter))
        Chapter.stub!(:new).and_return(@chapter)
      end

      it 'should create the chapter' do
        Chapter.should_receive(:new).with("name"=>"value").and_return(@chapter)
        do_create
      end

      it 'should save the chapter' do
        @chapter.should_receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(@chapter))
        do_create
      end

      it 'should re-render new' do
        do_create
        response.should render_template 'chapters/new'
        #response.should redirect_to chapters_url
      end

    end
  end

  describe "PUT update" do
    describe "with valid chapter" do
      before :each do
        @chapter = mock_model(Chapter, :update_attributes! => true)
        Chapter.stub!(:find).with(1).and_return(@chapter)
      end
      
      it 'should find the chapter' do
        Chapter.should_receive(:find).with(1).and_return(@chapter)
        do_update
      end

      it 'should update the chapter' do
        @chapter.should_receive(:update_attributes!).with("name"=>"value").and_return(true)
        do_update
      end

      it 'should flash "chapter update"' do
        do_update
        flash[:notice].should =~ /chapter updated/i
      end

      it 'should redirect to the updated chapter' do
        do_update
        response.should redirect_to chapter_url(@chapter)
      end
    end

    describe "with invalid chapter" do
      before :each do
        @chapter = mock_model(Chapter)
        @chapter.stub!(:update_attributes!).with("name"=>"value").and_raise(ActiveRecord::RecordInvalid.new(@chapter))
        Chapter.stub!(:find).with(1).and_return(@chapter)
      end

      it 'should find the chapter' do
        Chapter.should_receive(:find).with(1).and_return(@chapter)
        do_update
      end

      it 'should update the chapter' do
        @chapter.should_receive(:update_attributes!).with("name"=>"value").and_raise(ActiveRecord::RecordInvalid.new(@chapter))
        do_update
      end

      it 'should re-render edit' do
        do_update
        response.should render_template 'chapters/edit'
      end
    end

    it 'should be not found if find returns nil'
  end
end
