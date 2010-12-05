require 'spec_helper'

describe GeographicLocationsController do
  def mock_location
    @location ||= mock_model(GeographicLocation)
  end

  describe 'GET index' do
  end

  describe 'GET show' do
    before :each do
      GeographicLocation.stub(:find) { mock_location }
    end

    it 'should assign location with the given location' do
      GeographicLocation.should_receive(:find).with(1).and_return(mock_location)
      get :show, :id => 1
      assigns[:location].should == mock_location
    end

    it 'should be successful' do
      get :show, :id => 1
      response.should be_success
    end
  end

  describe 'GET new' do
    before :each do
      @admin = Factory(:admin)
      sign_in @admin
    end

    describe 'with a parent territory location selected' do
      before :each do
        GeographicLocation.stub(:find).and_return(mock_location)
        GeographicLocation.stub(:new).and_return(mock_location)
      end

      it 'should assign parent with the given location' do
        GeographicLocation.should_receive(:find).with(1).and_return(mock_location)
        get :new, :parent_id => 1
        assigns[:parent].should == mock_location
      end

      it 'should assign location with a new location' do
        GeographicLocation.should_receive(:new).and_return(mock_location)
        get :new, :parent_id => 1
        assigns[:location].should == mock_location
      end

      it 'should be successful' do
        get :new, :parent_id => 1
        response.should be_success
      end
    end
  end

  describe "POST create" do
    before :each do
      @admin = Factory(:admin)
      sign_in @admin
    end

    def post_create
      post :create, :geographic_location => {"with"=>"params"}, :parent_id => 1
    end

    describe 'with a parent territory location selected' do
      before :each do
        GeographicLocation.stub(:find).and_return(mock_location)
        GeographicLocation.stub(:new).and_return(mock_location)
        mock_location.stub(:save).and_return(true)
        mock_location.stub(:attributes=)
        mock_location.stub(:move_to_child_of)
      end

      it 'should assign parent with the given location' do
        GeographicLocation.should_receive(:find).with(1).and_return(mock_location)
        post :create, :with => "params", :parent_id => 1
        assigns[:parent].should == mock_location
      end

      it 'should assign location with a new location and the given params' do
        GeographicLocation.should_receive(:new).and_return(mock_location)
        mock_location.should_receive(:attributes=).with({"with"=>"params"})
        post :create, :geographic_location => {"with"=>"params"}, :parent_id => 1
        assigns[:location].should == mock_location
      end

      it 'should save the location' do
        mock_location.should_receive(:save).and_return(true)
        post_create
      end

      it 'should redirect to the newly created location page' do
        post_create
        response.should redirect_to(geo_path(mock_location))
      end

      it 'should redirect to the new chapter page with the location id if we came from there' do
        session[:return_to] = new_chapter_url
        post_create
        response.should redirect_to(new_chapter_url(:location_id => mock_location.id))
      end

      it 'should have a flash success' do
        post_create
        flash[:success].should_not be_nil
      end

      it 'should render the new template if validation fails' do
        mock_location.stub(:save).and_return(false)
        post_create
        response.should render_template('geographic_locations/new')
      end
    end
  end
end
