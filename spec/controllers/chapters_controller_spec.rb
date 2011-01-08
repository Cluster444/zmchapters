require 'spec_helper'

describe ChaptersController do
  let(:chapter)     { mock_model(Chapter, :name => 'test') }
  let(:coordinator) { mock_model(Coordinator) }
  let(:link)        { mock_model(Link) }
  let(:location)    { mock_model(Location) }
  let(:event)       { mock_model(Event, :plannable => chapter) }
  let(:map)         { { :lat => 0, :lng => 0, :zoom => 2, :markers => [], :events => false } }
  let(:params)      { Factory.attributes_for(:chapter).stringify_keys }
  let(:location_params) { Factory.attributes_for(:location) }

  describe 'routing' do
    # By ID
    it { should route(:get,    '/chapters').to(       :action => :index)             }
    it { should route(:get,    '/chapters/1').to(     :action => :show,    :id => 1) }
    it { should route(:get,    '/chapters/new').to(   :action => :new)               }
    it { should route(:get,    '/chapters/1/edit').to(:action => :edit,    :id => 1) }
    it { should route(:post,   '/chapters').to(       :action => :create)            }
    it { should route(:put,    '/chapters/1').to(     :action => :update,  :id => 1) }
    
    # By Name
    it { should route(:get, '/SomeChapter').to(     :action => :show,   :chapter_name => 'SomeChapter') }
    it { should route(:get, '/SomeChapter/edit').to(:action => :edit,   :chapter_name => 'SomeChapter') }
    it { should route(:put, '/SomeChapter').to(     :action => :update, :chapter_name => 'SomeChapter') }

    # No Destroy
    it { should_not route(:delete, '/chapters/1').to( :action => :destroy, :id => 1) }
    it { should_not route(:delete, '/SomeChapter').to(:action => :destroy, :chapter_name => 'SomeChapter') }
  end

  before :each do
    location.stub(:map_hash) { map }
    chapter.stub(:coordinators) { [] }
    User.stub(:new) { mock_model(User, :admin? => true) }
  end

  describe "GET #index" do
    before do
      Chapter.should_receive(:search) { [chapter] }
      Location.should_receive(:map_hash) { map }
      get :index
    end

    subject { controller }
    it { should assign_to(:chapters).with([chapter]) }
    it { should assign_to(:map).with(map) }
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
    before do
      Chapter.should_receive(:new) { chapter }
      get :new
    end
    subject { controller }
    it { should assign_to(:chapter).with(chapter) }
    it { should render_template :new }
    it { should respond_with :success }
  end

  describe 'GET edit' do
    before :each do
      Chapter.should_receive(:find).with(chapter.id) { chapter }
      chapter.should_receive(:location) { location }
      chapter.should_receive(:links) { [link] }
      location.should_receive(:map_hash) { map }
      get :edit, :id => chapter.id
    end

    subject { controller }
    it { should assign_to(:chapter).with(chapter) }
    it { should assign_to(:location).with(location) }
    it { should assign_to(:links).with([link]) }
    it { should assign_to(:map).with(map.merge(:events => true)) }
    it { should render_template :edit }
    it { should respond_with :success }
  end

  describe 'POST create' do
    def create(opts={})
      post :create, opts.merge!(:chapter => params)
    end

    before do
      Chapter.should_receive(:new) { chapter }
      chapter.should_receive(:attributes=).with(params)
    end

    context 'when validation passes' do
      before do
        chapter.should_receive(:save!)
        create
      end
      subject { controller }
      it { should assign_to(:chapter).with(chapter) }
      it { should_not set_the_flash }
      it { should redirect_to(new_location_url(:locateable_type => 'Chapter', :locateable_id => chapter.id, :return_to => "Chapter##{chapter.id}")) }
    end

    context 'when validation fails' do
      before do
        chapter.stub(:save!) { record_invalid(chapter) }
        create
      end

      subject { controller }
      it { should render_template :new }
      it { should respond_with :success }
    end
  end

  describe 'PUT update' do
    def update(opts={})
      opts.merge!(:id => chapter.id, :chapter => params)
      put :update, opts
    end
    
    before do
      Chapter.should_receive(:find).with(chapter.id) { chapter }
      chapter.stub :location => location
      chapter.stub :links => [link]
    end
    
    context 'when validation passes' do
      before do
        chapter.should_receive(:update_attributes!).with(params.stringify_keys)
        update
      end
      
      it { should assign_to(:chapter).with(chapter) }
      it { should set_the_flash }
      it { should redirect_to(chapter_path(chapter.name)) }
    end

    context 'when validation fails' do
      before do
        chapter.stub(:update_attributes!) { record_invalid(chapter) }
        update
      end
      subject { controller }
      it { should render_template :edit }
      it { should respond_with :success }
    end
  end
end
