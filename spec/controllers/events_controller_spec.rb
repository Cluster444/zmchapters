require 'spec_helper'

describe EventsController do
  def mock_event
    @event ||= mock_model(Event)
  end

  def mock_plannable
    @plannable ||= mock_model(Chapter)
  end
  
  before :each do
    User.stub :new => mock_model(User, :admin? => true)
    Event.stub :find => mock_event
    Event.stub :paginate => [mock_event]
    Event.stub :new => mock_event
  end

  describe "GET #index" do
    before :each do
      get :index
    end

    subject { controller }
    it { should assign_to :events }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe "GET #index.xml" do
    before :each do
      get :index, :format => :xml
    end

    subject { controller }
    it { should assign_to :events }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe "GET #show" do
    before :each do
      get :show, :id => 1
    end

    subject { controller }
    it { should assign_to :event }
    it { should render_template :show }
    it { should respond_with :success }
  end

  describe "GET #new" do
    describe 'when a valid plannable is given' do
      before :each do
        Chapter.stub :find => mock_plannable
        get :new, :plannable_type => "Chapter", :plannable_id => 1
      end

      subject { controller }
      it { should assign_to :event }
      it { should assign_to :plannable }
      it { should render_template :new }
      it { should respond_with :success }
    end

    describe 'when an invalid plannable is given' do
      before :each do
        Chapter.stub :find => mock_plannable
        get :new, :plannable_type => "Cahpter", :plannable_id => 1 #intentional typo on chapter
      end

      subject { controller }
      it { should assign_to :event }
      it { should_not assign_to :plannable }
      it { should render_template :new }
      it { should respond_with :success }
    end

    describe 'when an invalid plannable id is given' do
      before :each do
        Chapter.stub(:find) { raise ActiveRecord::RecordNotFound }
        get :new, :plannable_type => "Chapter", :plannable_id => 1
      end

      subject { controller }
      it { should assign_to :event }
      it { should_not assign_to :plannable }
      it { should render_template :new }
      it { should respond_with :success }
    end
  end

  describe "GET #edit" do
    before :each do
      get :edit, :id => 1
    end

    subject { controller }
    it { should assign_to :event }
    it { should render_template :edit }
    it { should respond_with :success }
  end
  
  describe "POST #create" do
    def record_invalid
      raise ActiveRecord::RecordInvalid.new(mock_event)
    end

    describe 'when validation passes' do
      before :each do
        mock_event.stub :save!
        post :create, :event => {"with"=>"params"}
      end

      subject { controller }
      it { should assign_to :event }
      it { should set_the_flash }
      it { should redirect_to event_url(mock_event) }
    end

    describe 'when validation fails' do
      before :each do
        mock_event.stub(:save!) { record_invalid }
        post :create, :event => {"with"=>"params"}
      end

      subject { controller }
      it { should assign_to :event }
      it { should render_template :new }
    end
  end
  describe "PUT #update" do
    def record_invalid
      raise ActiveRecord::RecordInvalid.new(mock_event)
    end

    describe 'when validation passes' do
      before :each do
        mock_event.stub :update_attributes!
        put :update, :id => 1, :event => {"with"=>"params"}
      end

      subject { controller }
      it { should assign_to :event }
      it { should set_the_flash }
      it { should redirect_to event_url(mock_event) }
    end

    describe 'when validation fails' do
      before :each do
        mock_event.stub(:update_attributes!) { record_invalid }
        put :update, :id => 1, :event => {"with"=>"params"}
      end

      subject { controller }
      it { should assign_to :event }
      it { should render_template :edit }
      it { should respond_with :success }
    end
  end
end
