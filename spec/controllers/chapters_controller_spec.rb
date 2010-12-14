require 'spec_helper'

describe ChaptersController do
  let(:chapter)     { mock_model(Chapter, :name => 'test') }
  let(:coordinator) { mock_model(Coordinator) }
  let(:link)        { mock_model(Link) }
  let(:location)    { mock_model(GeographicLocation) }
  let(:event)       { mock_model(Event, :plannable => chapter) }
  let(:map)         { { :lat => 0, :lng => 0, :zoom => 2, :markers => [], :events => false } }

  def mock_chapter
    chapter
  end
  
  def mock_link
    link
  end

  def mock_location
    location
  end

  def mock_event
    event
  end

  def mock_map
    map
  end

  def record_invalid; raise ActiveRecord::RecordInvalid.new(chapter); end

  before :each do
    mock_location.stub(:map_hash) { mock_map }
    mock_chapter.stub(:coordinators) { [] }
    User.stub(:new) { mock_model(User, :admin? => true) }
  end

  describe "GET #index" do
    before :each do
      Chapter.stub :index => [mock_chapter]
      GeographicLocation.stub :map_hash => mock_map
      get :index
    end

    subject { controller }
    it { should assign_to :chapters }
    it { should assign_to :map }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe "GET show" do
    before do
      Chapter.stub :find_by_name => nil
      Chapter.stub :find => chapter
      Chapter.should_receive(:find_all_by_location).with(location) { [chapter] }
      chapter.should_receive(:location) { location }
      chapter.should_receive(:links) { [link] }
      chapter.should_receive(:events) { [event] }
      chapter.should_receive(:coordinators) { [] }
    end

    context 'when using a chapter named route' do
      before { Chapter.should_receive(:find_by_name).with(chapter.name) { chapter } }
      before { Chapter.should_not_receive(:find) }
      before { get :show, :chapter_name => chapter.name }
      subject { controller }
      it { should assign_to(:chapter).with(chapter) }
    end

    context 'when using a chapter id route' do
      before { Chapter.should_receive(:find_by_name).with(nil) { nil } }
      before { Chapter.should_receive(:find).with(chapter.id) { chapter } }
      before { get :show, :id => chapter.id }
      subject { controller }
      it { should assign_to(:chapter).with(chapter) }
    end
    
    context do
      before  { get :show, :id => chapter.id }
      subject { controller }
      it { should assign_to(:subchapters).with([chapter]) }
      it { should assign_to(:location).with(location) }
      it { should assign_to(:links).with([link]) }
      it { should assign_to(:events).with([event]) }
      it { should assign_to(:coordinators) }
      it { should render_template :show }
      it { should respond_with :success }
    end
  end

  describe "GET new" do
    def new
      get :new, :location_id => 1
    end

    before :each do
      GeographicLocation.stub :find_by_id    => mock_location
      mock_location.stub      :name => 'foo'
      mock_location.stub      :is_country?   => false
      mock_location.stub      :is_territory? => false
      get :new, :location_id => 1
    end

    subject { controller }
    it { should assign_to :location }

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
      mock_chapter.stub :links => [mock_link]
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

    it 'should assign links with the chapter\'s links' do
      mock_chapter.should_receive(:links) { [mock_link] }
      edit
      assigns[:links].should == [mock_link]
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
  
  describe 'POST create_link' do
    def create(opts={})
      opts.merge!(:id => 1, :link => {"with"=>"params"})
      post :create_link, opts
    end

    before :each do
      Link.stub :new => mock_link
      Chapter.stub :find => mock_chapter
      mock_link.stub :linkable=
      mock_link.stub :save!
    end
    
    it 'should assign link with a new record' do
      Link.should_receive(:new).with({"with"=>"params"}) { mock_link }
      create
      assigns[:link].should == mock_link
    end

    it 'should associate the current chapter with the link' do
      mock_link.should_receive(:linkable=).with(mock_chapter)
      create
    end

    it 'should save the record' do
      mock_link.should_receive(:save!)
      create
    end

    it 'should redirect to the chapter\'s page with a flash notice' do
      create
      response.should redirect_to(chapter_path(mock_chapter))
      flash[:notice].should_not be_nil
    end
    
    describe 'when validation fails' do
      before :each do
        mock_link.stub(:save!) { record_invalid }
        mock_chapter.stub :location => mock_location
        mock_chapter.stub :links => [mock_link]
        mock_location.stub :map_hash => mock_map
      end
      
      it 'should assign location with the chapter\'s location' do
        mock_chapter.should_receive(:location) { mock_location }
        create
        assigns[:location].should == mock_location
      end
      
      it 'should assign map with the chapter\'s location\'s map hash' do
        mock_location.should_receive(:map_hash) { mock_map }
        create
        assigns[:map].symbolize_keys.should == mock_map.merge(:events => true)
      end

      it 'should assign links with the chapter\'s links' do
        mock_chapter.should_receive(:links) { [mock_link] }
        create
        assigns[:links].should == [mock_link]
      end

      it 'should render edit' do
        create
        response.should render_template('chapters/edit')
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
        mock_chapter.stub :links => [mock_link]
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

      it 'should assign links with the chapter\'s links' do
        mock_chapter.should_receive(:links) { [mock_link] }
        update
        assigns[:links].should == [mock_link]
      end

      it 'should render edit' do
        update
        response.should render_template('chapters/edit')
      end
    end
  end

  describe 'PUT update_link' do
    def update(opts={})
      opts.merge!(:id => 1, :link_id => 2, :link => {"with"=>"params"})
      put :update_link, opts
    end
    
    before :each do
      Chapter.stub :find => mock_chapter
      Link.stub :find => mock_link
      mock_link.stub :update_attributes!
    end

    it 'should assign link with the requested record' do
      Link.should_receive(:find).with(2) { mock_link }
      update
      assigns[:link].should == mock_link
    end

    it 'should update the link with the given params' do
      mock_link.should_receive(:update_attributes!).with({"with"=>"params"})
      update
    end

    it 'should redirect to the chapter\'s page with a flash notice' do
      update
      response.should redirect_to(chapter_path(mock_chapter))
      flash[:notice].should_not be_nil
    end

    describe 'when validation fails' do
      before :each do
        mock_link.stub(:update_attributes!) { record_invalid }
        mock_chapter.stub :location => mock_location
        mock_chapter.stub :links => [mock_link]
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

      it 'should assign links with the chapter\'s links' do
        mock_chapter.should_receive(:links) { [mock_link] }
        update
        assigns[:links].should == [mock_link]
      end

      it 'should render edit' do
        update
        response.should render_template('chapters/edit')
      end
    end
  end
end
