require 'spec_helper'

describe ChaptersController do
  def mock_chapter
    @chapter ||= mock_model(Chapter)
  end

  def mock_location
    @location ||= mock_model(GeographicLocation, :name => "Geo")
  end

  describe "GET index" do
    before :each do
      @admin = Factory(:admin)
      sign_in @admin
    end

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

    describe 'with a map view' do
      def mock_location
        @location ||= mock_model(GeographicLocation)
      end

      it 'should assign map with default positioning and chapter markers' do
        GeographicLocation.stub(:markers) { [mock_location] }
        get :index, :view => 'map'
        assigns[:map].should == {'lat' => 0, 'lng' => 0, 'zoom' => 2, 'markers' => [mock_location]}
      end
    end
  end

  describe "GET show" do
    describe "for a record that exists" do
      before :each do
        Chapter.stub!(:find).and_return(mock_chapter)
        Chapter.stub!(:find_all_by_location) { [] }
        mock_chapter.stub!(:geographic_location).and_return(mock_location)
        mock_chapter.stub!(:location) { mock_location }
      end

      it 'should assign chapter with the requested record' do
        Chapter.should_receive(:find).with(1).and_return(mock_chapter)
        get :show, :id => 1
        assigns[:chapter].should == mock_chapter
      end
      
      it 'should assign subchapters with descendent chapters' do
        Chapter.should_receive(:find_all_by_location).with(mock_location) { [mock_chapter] }
        get :show, :id => 1
        assigns[:subchapters].should == [mock_chapter]
      end

      it 'should assign location from the chapters location' do
        mock_chapter.should_receive(:location) { mock_location }
        get :show, :id => 1
        assigns[:location].should == mock_location
      end

      it 'should be successful' do
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
end
