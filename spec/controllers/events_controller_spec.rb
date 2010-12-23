require 'spec_helper'

describe EventsController do
  let(:event)   { mock_model(Event) }
  let(:chapter) { mock_model(Chapter) }
  let(:params)  { Factory.attributes_for(:event).stringify_keys }
  let(:plannable_params) { {:type => 'Chapter', :id => chapter.id} }

  before :each do
    User.stub  :new => mock_model(User, :admin? => true)
  end

  describe "GET #index" do
    before do
      Event.stub_chain(:accessible_by, :search) { [event] }
      get :index
    end
    subject { controller }
    it { should assign_to(:events).with([event]) }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe "GET #index.xml" do
    before do
      Event.stub_chain(:accessible_by, :search) { [event] }
      get :index, :format => :xml
    end
    subject { controller }
    it { should assign_to(:events).with([event]) }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe "GET #show" do
    before do
      Event.should_receive(:find).with(event.id) { event }
      get :show, :id => event.id
    end
    subject { controller }
    it { should assign_to(:event).with(event) }
    it { should render_template :show }
    it { should respond_with :success }
  end

  describe "GET #new" do
    before do
      Event.should_receive(:new) { event }
    end
    context 'when a valid plannable is given' do
      before do
        Chapter.should_receive(:find).with(chapter.id) { chapter }
        event.should_receive(:plannable=).with(chapter)
        get :new, :plannable => plannable_params
      end
      subject { controller }
      it { should assign_to :event }
      it { should render_template :new }
      it { should respond_with :success }
    end

    context 'when an invalid plannable is given' do
      before { get :new, :plannable_type => "NotAModel", :plannable_id => 1 }
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(Event) }
    end

    context 'when an invalid plannable id is given' do
      before do
        Chapter.stub(:find) { record_not_found }
        get :new, :plannable => plannable_params
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(Event) }
    end
  end

  describe "GET #edit" do
    before do
      Event.should_receive(:find).with(event.id) { event }
      get :edit, :id => event.id
    end
    subject { controller }
    it { should assign_to(:event).with(event) }
    it { should render_template :edit }
    it { should respond_with :success }
  end
  
  describe "POST #create" do
    before do
      Event.should_receive(:new) { event }
      event.should_receive(:attributes=).with(params)
      Chapter.should_receive(:find).with(chapter.id) { chapter }
      event.should_receive(:plannable=).with(chapter)
    end

    context 'when validation passes' do
      before do
        event.should_receive(:save!)
        post :create, :event => params, :plannable => plannable_params
      end
      subject { controller }
      it { should assign_to :event }
      it { should set_the_flash }
      it { should redirect_to(event) }
    end

    context 'when validation fails' do
      before do
        event.stub(:save!) { record_invalid(event) }
        post :create, :event => params, :plannable => plannable_params
      end
      subject { controller }
      it { should assign_to :event }
      it { should render_template :new }
      it { should respond_with :success }
    end
  end
  
  describe "PUT #update" do
    before { Event.should_receive(:find).with(event.id) { event } }
    context 'when validation passes' do
      before do
        event.should_receive(:update_attributes!)
        put :update, :id => event.id, :event => params
      end
      subject { controller }
      it { should assign_to :event }
      it { should set_the_flash }
      it { should redirect_to(event) }
    end

    context 'when validation fails' do
      before do
        event.stub(:update_attributes!) { record_invalid(event) }
        put :update, :id => event.id, :event => params
      end
      subject { controller }
      it { should assign_to :event }
      it { should render_template :edit }
      it { should respond_with :success }
    end
  end

  describe "DELETE #destroy" do
    before do
      Event.should_receive(:find).with(event.id) { event }
      event.should_receive(:destroy)
      delete :destroy, :id => event.id
    end
    subject { controller }
    it { should set_the_flash }
    it { should redirect_to(Event) }
  end
end
