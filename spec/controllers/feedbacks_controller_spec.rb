require 'spec_helper'

describe FeedbacksController do
  let(:feedback) { mock_model(Feedback) }
  let(:user)     { mock_model(User) }
  let(:admin)    { mock_model(User, :admin? => true) }
  let(:params)   { Factory.attributes_for(:feedback).stringify_keys }

  describe 'routing' do
    it { should route(:get,    '/feedback').to(       :action => :index)             }
    it { should route(:get,    '/feedback/1').to(     :action => :show,    :id => 1) }
    it { should route(:get,    '/feedback/new').to(   :action => :new)               }
    it { should route(:get,    '/feedback/1/edit').to(:action => :edit,    :id => 1) }
    it { should route(:post,   '/feedback').to(       :action => :create)            }
    it { should route(:put,    '/feedback/1').to(     :action => :update,  :id => 1) }
    it { should_not route(:delete, '/feedback/1').to(     :action => :destroy, :id => 1) }
  end
  
  describe "GET 'index'" do
    before { User.stub(:new) { admin } }
    before do
      Feedback.should_receive(:search) { [feedback] }
      get :index
    end

    subject { controller }
    it { should assign_to(:feedbacks).with([feedback]) }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe "GET 'show'" do
    before { User.stub(:new) { admin } }
    before do
      Feedback.should_receive(:find).with(feedback.id) { feedback }
      get :show, :id => feedback.id
    end
    
    subject { controller }
    it { should assign_to(:feedback).with(feedback) }
    it { should render_template :show }
    it { should respond_with :success }
  end

  describe "GET 'new'" do
    before { User.stub(:new) { admin } }
    before :each do
      Feedback.should_receive(:new) { feedback }
      get :new
    end

    subject { controller }
    it { should assign_to(:feedback).with(feedback) }
    it { should render_template :new }
    it { should respond_with :success }
  end

  describe "GET 'edit' " do
    before { User.stub(:new) { admin } }
    before :each do
      Feedback.should_receive(:find).with(feedback.id) { feedback }
      get :edit, :id => feedback.id
    end

    subject { controller }
    it { should assign_to(:feedback).with(feedback) }
    it { should render_template :edit }
    it { should respond_with :success }
  end

  describe "POST 'create'" do
    def create
      post :create, :feedback => params
    end

    before do
      Feedback.should_receive(:new) { feedback }
      feedback.should_receive(:attributes=).with(params)
    end

    describe "when signed in" do
      before do
        @admin = Factory(:admin)
        sign_in @admin
        feedback.stub :user=
      end
      
      context 'when validation passes' do
        before do
          feedback.should_receive(:save!)
          create
        end

        subject { controller }
        it { should assign_to(:feedback).with(feedback) }
        it { should set_the_flash }
        it { should redirect_to(feedback) }
      end

      context 'when validation fails' do
        before do
          feedback.stub(:save!) { record_invalid(feedback) }
          create
        end

        subject { controller }
        it { should assign_to(:feedback).with(feedback) }
        it { should render_template :new }
        it { should respond_with :success }
      end
    end

    describe "when not signed in" do
      before do
        SiteOption.stub(:find_by_key) { mock_model(SiteOption, :value => 'public') }
        Feedback.should_receive(:new) { feedback }
        feedback.should_receive(:save!)
        create
      end

      subject { controller }
      it { should assign_to(:feedback).with(feedback) }
      it { should set_the_flash }
      it { should redirect_to(home_url) }
    end
  end

  describe "PUT 'update'" do
    before { User.stub(:new) { admin } }

    before do
      Feedback.should_receive(:find).with(feedback.id) { feedback }
    end
    
    context 'when validation passes' do
      before do
        feedback.should_receive(:update_attributes!).with(params)
        put :update, :id => feedback.id, :feedback => params
      end

      subject { controller }
      it { should assign_to(:feedback).with(feedback) }
      it { should set_the_flash }
      it { should redirect_to(feedback) }
    end

    context 'when validation fails' do
      before do
        feedback.stub(:update_attributes!) { record_invalid(feedback) }
        put :update, :id => feedback.id, :feedback => params
      end

      subject { controller }
      it { should assign_to(:feedback).with(feedback) }
      it { should render_template :edit }
      it { should respond_with :success }
    end
  end
end
