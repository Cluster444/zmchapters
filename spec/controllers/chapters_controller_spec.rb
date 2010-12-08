require 'spec_helper'

describe ChaptersController do
  def mock_chapter
    @chapter ||= mock_model(Chapter)
  end

  def mock_location
    @location ||= mock_model(GeographicLocation, :name => "Geo")
  end

  def mock_map
    { :lat => 0, :lng => 0, :zoom => 2, :markers => [], :events => false }
  end

  def record_invalid
    raise ActiveRecord::RecordInvalid.new(mock_chapter)
  end

  before :each do
    mock_location.stub(:map_hash) { mock_map }
    User.stub(:new) { mock_model(User, :admin? => true) }
  end

  describe "GET index" do
    it 'should be successful' do
      get :index
      response.should be_success
    end

    it 'assigns chapters with records returned from the model\'s index' do
      Chapter.should_receive(:index).and_return([mock_chapter])
      get :index
      assigns[:chapters].should == [mock_chapter]
    end

    it 'should assign map with default positioning and chapter markers' do
      GeographicLocation.should_receive(:map_hash) { mock_map }
      get :index, :view => 'map'
      assigns[:map].symbolize_keys.should == mock_map
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

      it 'should be successful' do
        get :show, :id => 1
        response.should be_success
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
        flash[:alert].should_not be_nil
      end
    end
  end

  describe "GET new" do
    def new
      get :new, :location_id => 1
    end

    before :each do
      GeographicLocation.stub :find_by_id    => mock_location
      mock_location.stub      :is_country?   => false
      mock_location.stub      :is_territory? => false
    end
    
    it 'should assign location with the given location' do
      GeographicLocation.should_receive(:find_by_id).with(1) { mock_location }
      new
      assigns[:location].should == mock_location
    end

    describe 'with no geography selected' do
      before :each do
        GeographicLocation.stub(:find_by_id => nil)
      end

      it 'should redirect to the chapter map page' do
        get :new
        response.should redirect_to(chapters_path)
      end

      it 'should have a flash error' do
        get :new
        flash[:alert].should_not be_nil
      end
    end

    it 'should assign map with a map hash from the location with events on' do
      mock_location.should_receive(:map_hash) { mock_map }
      new
      assigns[:map].symbolize_keys.should == mock_map.merge(:events => true)
    end

    it 'should assign the chapter\'s location' do
      new
      assigns[:chapter].geographic_location.should == mock_location
    end

    it 'should assign the chapter\'s name' do
      new
      assigns[:chapter].name.should == mock_location.name
    end

    describe 'with a country selected' do
      it 'should assign the chapter\'s category to country' do
        mock_location.stub :is_country? => true
        new
        assigns[:chapter].category.should == 'country'
      end
    end

    describe 'with a territory selected and the category is a subchapter' do
      before :each do
        mock_location.stub :is_territory? => true
      end

      it 'should set a session return to new chapter path' do
        get :new, :location_id => 1, :category => 'subchapter'
        session[:return_to].should == new_chapter_path
      end

      it 'should redirect to new geo path with a parnet_id param' do
        get :new, :location_id => 1, :category => 'subchapter'
        response.should redirect_to(new_geo_url(:parent_id => mock_location.id))
      end
    end
  end

  describe 'GET edit' do
    def edit
      get :edit, :id => 1
    end

    before :each do
      Chapter.stub :find => mock_chapter
      mock_chapter.stub :location => mock_location
      mock_location.stub :map_hash => mock_map
    end

    it 'should assign chapter with the requested record' do
      Chapter.should_receive(:find).with(1) { mock_chapter }
      get :edit, :id => 1
      assigns[:chapter].should == mock_chapter
    end

    it 'should assign location with the chapter\'s location' do
      mock_chapter.should_receive(:location) { mock_location }
      edit
      assigns[:location].should == mock_location
    end

    it 'should assign map with the location\'s map hash' do
      mock_location.should_receive(:map_hash) { mock_map }
      edit
      assigns[:map].symbolize_keys.should == mock_map.merge(:events => true)
    end
  end

  describe 'POST create' do
    def create(opts={})
      opts.merge!(:location_id => 1, :chapter => {"with"=>"params"})
      post :create, opts
    end

    before :each do
      GeographicLocation.stub :find => mock_location
      Chapter.stub :new => mock_chapter
      mock_chapter.stub :attributes=
      mock_chapter.stub :geographic_location=
      mock_chapter.stub :save!
    end

    it 'should assign chapter with a new record' do
      Chapter.should_receive(:new) { mock_chapter }
      mock_chapter.should_receive(:attributes=).with({"with"=>"params"})
      create
      assigns[:chapter].should == mock_chapter
    end
    
    it 'should assign location with the requested location' do
      GeographicLocation.should_receive(:find).with(1) { mock_location }
      create
      assigns[:location].should == mock_location
    end

    describe 'when a location param exists' do
      it 'should update the location\'s attributes' do
        mock_location.should_receive(:update_attributes).with({"with"=>"params"})
        create :location => {"with"=>"params"}
      end
    end

    it 'should assign the chapter\'s location with the requested location' do
      mock_chapter.should_receive(:geographic_location=).with(mock_location)
      create
    end

    it 'should save the record' do
      mock_chapter.should_receive(:save!)
      create
    end

    it 'should redirect to the chapter\'s page with a flash notice' do
      create
      response.should redirect_to(mock_chapter)
      flash[:notice].should_not be_nil
    end

    describe 'when validation fails' do
      before :each do
        mock_chapter.stub(:save!) { record_invalid }
      end

      it 'should assign map with the location\'s map hash' do
        mock_location.should_receive(:map_hash) { mock_map }
        create
        assigns[:map].symbolize_keys.should == mock_map.merge(:events => true)
      end

      it 'should render new' do
        create
        response.should render_template('chapters/new')
      end
    end
  end

  describe 'PUT update' do
    def update(opts={})
      opts.merge!(:id => 1, :chapter => {"with"=>"params"})
      put :update, opts
    end
    
    before :each do
      Chapter.stub :find => mock_chapter
      mock_chapter.stub :update_attributes!
    end

    it 'should assign chapter with the requested record' do
      Chapter.should_receive(:find).with(1) { mock_chapter }
      update
      assigns[:chapter].should == mock_chapter
    end

    describe 'when a location param exists' do
      it 'should update the location\'s attributes' do
        mock_chapter.should_receive(:location) { mock_location }
        mock_location.should_receive(:update_attributes).with({"with"=>"params"})
        update :location => {"with"=>"params"}
      end
    end

    it 'should update the chapter\'s attributes' do
      mock_chapter.should_receive(:update_attributes!).with({"with"=>"params"})
      update
    end

    it 'should redirect to the chapter\'s page with a flash notice' do
      update
      response.should redirect_to(mock_chapter)
      flash[:notice].should_not be_nil
    end

    describe 'when validation fails' do
      before :each do
        mock_chapter.stub(:update_attributes!) { record_invalid }
        mock_chapter.stub :location => mock_location
        mock_location.stub :map_hash => mock_map
      end

      it 'should assign location with the chapter\'s location' do
        mock_chapter.should_receive(:location) { mock_location }
        update
        assigns[:location].should == mock_location
      end

      it 'should assign map with the location\'s map hash' do
        mock_location.should_receive(:map_hash) { mock_map }
        update
        assigns[:map].symbolize_keys.should == mock_map.merge(:events => true)
      end

      it 'should render edit' do
        update
        response.should render_template('chapters/edit')
      end
    end
  end
end
