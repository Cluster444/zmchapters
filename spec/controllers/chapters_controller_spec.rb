require 'spec_helper'

describe ChaptersController do
  def mock_chapter
    @chapter ||= mock_model(Chapter)
  end

  def mock_location
    @location ||= mock_model(GeographicLocation, :name => "Geo")
  end

  describe "GET index" do
    it 'assigns all chapters as @chapters' do
      Chapter.should_receive(:index).and_return([mock_chapter])
      get :index
      assigns[:chapters].should == [mock_chapter]
    end

    it 'should be successful' do
      get :index
      response.should be_success
    end

    it 'should render the index template' do
      get :index
      response.should render_template('chapters/index')
    end

    it 'should pass through all params to the model index call' do
      input_params = {"search" => 'foo', "sort" => 'foo', "direction" => 'asc', "per_page" => 15, "page" => 3}
      Chapter.should_receive(:index).with(input_params)
      get :index, input_params
    end

    it 'should filter params that the model doesn\'t need' do
      Chapter.should_receive(:index).with({})
      get :index
    end
  end

  describe "GET show" do
    describe "for a record that exists" do
      it 'should assign @chapter from the id' do
        Chapter.should_receive(:find).with(1).and_return(mock_chapter)
        get :show, :id => 1
        assigns[:chapter].should == mock_chapter
      end

      it 'should be successful' do
        Chapter.stub(:find).and_return(mock_chapter)
        get :show, :id => 1
        response.should be_success
      end
    end

    describe "for a record that doesn't exist" do
      before :each do
        Chapter.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      end
        
      it 'should redirect to the index with a flash error' do
        get :show, :id => 1
        response.should redirect_to(chapters_path)
      end

      it 'should have a flash error' do
        get :show, :id => 1
        flash[:error].should_not be_nil
      end
    end
  end

  describe "GET new" do
    before :each do
      GeographicLocation.stub(:find).with(1).and_return(mock_location)
      @admin = Factory(:admin)
      sign_in @admin
    end
    
    describe 'with no geography selected' do
      before :each do
        GeographicLocation.stub(:find).and_return(nil)
      end

      it 'should redirect to the chapter map page' do
        get :new
        response.should redirect_to(geo_index_path)
      end

      it 'should have a flash error' do
        get :new
        flash[:error].should_not be_nil
      end
    end

    describe 'with a country selected' do
      before :each do
        mock_location.stub(:is_country?).and_return(true)
      end

      it 'should assign a new chapter' do
        Chapter.should_receive(:new).and_return(mock_chapter)
        mock_chapter.stub(:name=)
        mock_chapter.stub(:category=)
        mock_chapter.stub(:geographic_location=)
        get :new, :location_id => 1
        assigns[:chapter].should == mock_chapter
      end

      it 'should set the chapter\'s location/name/category' do
        Chapter.stub(:new).and_return(mock_chapter)
        mock_chapter.should_receive(:geographic_location=).with(mock_location)
        mock_chapter.should_receive(:name=).with(mock_location.name)
        mock_chapter.should_receive(:category=).with('country')
        get :new, :location_id => 1
      end
    end

    describe 'with a territory selected' do
      before :each do
        Chapter.stub(:new).and_return(mock_chapter)
        mock_chapter.stub(:name=)
        mock_chapter.stub(:category=)
        mock_chapter.stub(:geographic_location=)
        mock_location.stub(:is_country?).and_return(false)
        mock_location.stub(:is_territory?).and_return(true)
      end

      describe 'when the category is not subchapter' do
        it 'should assign a new chapter' do
          Chapter.should_receive(:new).and_return(mock_chapter)
          get :new, :category => 'territory', :location_id => 1
          assigns[:chapter].should == mock_chapter
        end

        it 'should assign the location/name from the location' do
          mock_chapter.should_receive(:geographic_location=).with(mock_location)
          mock_chapter.should_receive(:name=).with(mock_location.name)
          mock_chapter.should_receive(:category=).with("territory")
          get :new, :category => 'territory', :location_id => 1
        end
      end

      describe 'when the category is subchapter' do
        it 'should redirect to the new location page' do
          get :new, :category => 'subchapter', :location_id => 1
          response.should redirect_to(new_geo_url(:parent_id => mock_location.id))
        end
      end
    end

    describe 'when a subterritory is selected' do
      before :each do
        Chapter.stub(:new).and_return(mock_chapter)
        mock_chapter.stub(:name=)
        mock_chapter.stub(:geographic_location=)
        mock_location.stub(:is_country?).and_return(false)
        mock_location.stub(:is_territory?).and_return(false)
        mock_location.stub(:is_subterritory?).and_return(true)
      end

      it 'should assign parent to the given location' do
        get :new, :location_id => 1
        assigns[:location].should == mock_location
      end

      it 'should assign the location/name of the given location' do
        mock_chapter.should_receive(:name=).with(mock_location.name)
        mock_chapter.should_receive(:geographic_location=).with(mock_location)
        get :new, :location_id => 1
      end
    end
  end

=begin
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
=end
end
