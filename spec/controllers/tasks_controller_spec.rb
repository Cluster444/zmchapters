require 'spec_helper'

describe TasksController do
  let(:task) { mock_model(Task) }
  let(:chapter) { mock_model(Chapter) }
  let(:params) { Factory.attributes_for(:task).stringify_keys }
  
  before { User.stub(:new) { mock_model(User, :admin? => true) } }
  
  describe 'routing' do
    it { should route(:get,    '/tasks').to(       :action => :index)             }
    it { should route(:get,    '/tasks/1').to(     :action => :show,    :id => 1) }
    it { should route(:get,    '/tasks/new').to(   :action => :new)               }
    it { should route(:get,    '/tasks/1/edit').to(:action => :edit,    :id => 1) }
    it { should route(:post,   '/tasks').to(       :action => :create)            }
    it { should route(:put,    '/tasks/1').to(     :action => :update,  :id => 1) }
    it { should route(:delete, '/tasks/1').to(     :action => :destroy, :id => 1) }
  end

  describe "GET #index" do
    before do
      Task.stub_chain(:accessible_by, :search) { [task] }
      get :index
    end

    subject { controller }
    it { should assign_to(:tasks).with([task]) }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe "GET #show" do
    before do
      Task.should_receive(:find).with(task.id) { task }
      get :show, :id => task.id
    end
    subject { controller }
    it { should assign_to(:task).with(task) }
    it { should render_template :show }
    it { should respond_with :success }
  end

  describe "GET #new" do
    before { Task.should_receive(:new) { task } }
    context 'when a valid taskable is given' do
      before do
        Chapter.should_receive(:find) { chapter }
        task.should_receive(:taskable=).with(chapter)
        get :new, :taskable => {:type => 'Chapter', :id => chapter.id}
      end
      subject { controller }
      it { should assign_to(:task).with(task) }
      it { should render_template :new }
      it { should respond_with :success }
    end

    context 'when an invalid taskable type is given' do
      before do
        get :new, :taskable => {:type => 'NotAModel', :id => 1}
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(Task) }
    end

    context 'when an invalid taskable id is given' do
      before do
        Chapter.stub(:find) { record_not_found }
        get :new, :taskable => {:type => 'Chapter', :id => nil}
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(Task) }
    end
  end

  describe "GET #edit" do
    before do
      Task.should_receive(:find).with(task.id) { task }
      get :edit, :id => task.id
    end
    subject { controller }
    it { should assign_to(:task).with(task) }
    it { should render_template :edit }
    it { should respond_with :success }
  end

  describe "POST #create" do
    before do
      Task.should_receive(:new) { task }
      task.should_receive(:attributes=).with(params)
      Chapter.should_receive(:find).with(chapter.id) { chapter }
      task.should_receive(:taskable=).with(chapter)
    end

    context 'when validation passses' do
      before do
        task.should_receive(:save!)
        post :create, :task => params, :taskable => {:type => 'Chapter', :id => chapter.id}
      end
      subject { controller }
      it { should assign_to(:task).with(task) }
      it { should set_the_flash }
      it { should redirect_to(task) }
    end

    context 'when validation fails' do
      before do
        task.stub(:save!) { record_invalid(task) }
        post :create, :task => params, :taskable => {:type => 'Chapter', :id => chapter.id}
      end
      subject { controller }
      it { should assign_to(:task).with(task) }
      it { should render_template :new }
      it { should respond_with :success }
    end
  end

  describe "PUT #update" do
    before do
      Task.should_receive(:find).with(task.id) { task }
    end

    context 'when validation passes' do
      before do
        task.should_receive(:update_attributes!)
        put :update, :id => task.id, :task => params
      end
      subject { controller }
      it { should assign_to(:task).with(task) }
      it { should set_the_flash }
      it { should redirect_to(task) }
    end

    context 'when validation fails' do
      before do
        task.stub(:update_attributes!) { record_invalid(task) }
        put :update, :id => task.id, :task => params
      end
      subject { controller }
      it { should assign_to(:task).with(task) }
      it { should render_template :edit }
      it { should respond_with :success }
    end
  end

  describe "DELETE destroy" do
    before do
      Task.should_receive(:find).with(task.id) { task }
      task.should_receive(:destroy)
      delete :destroy, :id => task.id
    end
    subject { controller }
    it { should set_the_flash }
    it { should redirect_to(Task) }
  end
end
