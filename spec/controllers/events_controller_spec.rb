require 'spec_helper'

describe EventsController do
  def mock_event
    @event ||= mock_model(Event)
  end

  def mock_plannable
    @plannable ||= mock_model(Chapter)
  end
  
  def record_invalid
    raise ActiveRecord::RecordInvalid.new(mock_event)
  end

  before :each do
    User.stub  :new      => mock_model(User, :admin? => true)
    Event.stub :find     => mock_event
    Event.stub :paginate => [mock_event]
    Event.stub :new      => mock_event
  end

  describe "GET #index" do
    before  { get :index }
    subject { controller }
    it { should assign_to :events }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe "GET #index.xml" do
    before  { get :index, :format => :xml }
    subject { controller }
    it { should assign_to :events }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe "GET #show" do
    before  { get :show, :id => 1 }
    subject { controller }
    it { should assign_to :event }
    it { should render_template :show }
    it { should respond_with :success }
  end

  describe "GET #new" do
    def new
      get :new, :plannable_type => "Chapter", :plannable_id => 1
    end

    describe 'when a valid plannable is given' do
      before  { Chapter.stub :find => mock_plannable }
      before  { new }
      subject { controller }
      it { should assign_to :event }
      it { should assign_to :plannable }
      it { should render_template :new }
      it { should respond_with :success }
    end

    describe 'when an invalid plannable is given' do
      before  { Chapter.stub :find => mock_plannable }
      before  { get :new, :plannable_type => "invalid", :plannable_id => 1 }
      subject { controller }
      it { should assign_to :event }
      it { should_not assign_to :plannable }
      it { should render_template :new }
      it { should respond_with :success }
    end

    describe 'when an invalid plannable id is given' do
      before  { Chapter.stub(:find) { raise ActiveRecord::RecordNotFound } }
      before  { new }
      subject { controller }
      it { should assign_to :event }
      it { should_not assign_to :plannable }
      it { should render_template :new }
      it { should respond_with :success }
    end
  end

  describe "GET #edit" do
    before  { get :edit, :id => 1 }
    subject { controller }
    it { should assign_to :event }
    it { should render_template :edit }
    it { should respond_with :success }
  end
  
  describe "POST #create" do
    def create
      post :create, :event => {"with"=>"params"}
    end

    before { mock_event.stub :attributes= }

    describe 'when validation passes' do
      before  { mock_event.stub :save! }
      before  { create }
      subject { controller }
      it { should assign_to :event }
      it { should set_the_flash }
      it { should redirect_to event_url(mock_event) }
    end

    describe 'when validation fails' do
      before  { mock_event.stub(:save!) { record_invalid } }
      before  { create }
      subject { controller }
      it { should assign_to :event }
      it { should render_template :new }
    end
  end
  
  describe "PUT #update" do
    def update
      put :update, :id => 1, :event => {"with"=>"params"}
    end

    describe 'when validation passes' do
      before { mock_event.stub :update_attributes! }
      before  { update }
      subject { controller }
      it { should assign_to :event }
      it { should set_the_flash }
      it { should redirect_to event_url(mock_event) }
    end

    describe 'when validation fails' do
      before  { mock_event.stub(:update_attributes!) { record_invalid } }
      before  { update }
      subject { controller }
      it { should assign_to :event }
      it { should render_template :edit }
      it { should respond_with :success }
    end
  end
end
