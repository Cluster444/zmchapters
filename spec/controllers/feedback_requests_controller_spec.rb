require 'spec_helper'

describe FeedbackRequestsController do
  let(:feedback) { mock_model(FeedbackRequest) }
  let(:user)     { mock_model(User) }
  let(:admin)    { mock_model(User, :admin? => true) }
  let(:params)   { Factory.attributes_for(:feedback_request).stringify_keys }

  def mock_feedback
    feedback
  end

  def mock_user
    user
  end

  def mock_admin
    admin
  end

  def create
    post :create, :feedback_request => params
  end

  def record_invalid; raise ActiveRecord::RecordInvalid.new(feedback); end

  
  describe "GET 'index'" do
    before { User.stub(:new) { admin } }
    before do
      FeedbackRequest.should_receive(:search) { [feedback] }
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
      FeedbackRequest.should_receive(:find).with(feedback.id) { feedback }
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
      FeedbackRequest.should_receive(:new) { feedback }
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
      FeedbackRequest.should_receive(:find).with(feedback.id) { feedback }
      get :edit, :id => feedback.id
    end

    subject { controller }
    it { should assign_to(:feedback).with(feedback) }
    it { should render_template :edit }
    it { should respond_with :success }
  end

  describe "POST 'create'" do
    def create
      post :create, :feedback_request => params
    end

    before do
      FeedbackRequest.should_receive(:new) { feedback }
      feedback.should_receive(:attributes=).with(params)
    end

    describe "when signed in" do
      before do
        @admin = Factory(:admin)
        sign_in @admin
        mock_feedback.stub :user=
      end
      
      context 'when validation passes' do
        before do
          feedback.should_receive(:save!)
          create
        end

        subject { controller }
        it { should assign_to(:feedback).with(feedback) }
        it { should set_the_flash }
        it { should redirect_to(feedback_request_path(mock_feedback)) }
      end

      context 'when validation fails' do
        before do
          feedback.stub(:save!) { record_invalid }
          create
        end

        subject { controller }
        it { should assign_to(:feedback).with(feedback) }
        it { should render_template :new }
      end
    end

    describe "when not signed in" do
      before do
        SiteOption.stub(:find_by_key) { mock_model(SiteOption, :value => 'public') }
        FeedbackRequest.should_receive(:new) { feedback }
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
    def update
      put :update, :id => feedback.id, :feedback_request => params
    end

    before do
      FeedbackRequest.should_receive(:find).with(feedback.id) { feedback }
    end
    
    context 'when validation passes' do
      before do
        feedback.should_receive(:update_attributes!).with(params)
        update
      end

      subject { controller }
      it { should assign_to(:feedback).with(feedback) }
      it { should set_the_flash }
      it { should redirect_to(feedback_request_url(feedback)) }
    end

    context 'when validation fails' do
      before do
        feedback.stub(:update_attributes!) { record_invalid }
        update
      end

      subject { controller }
      it { should assign_to(:feedback).with(feedback) }
      it { should render_template :edit }
    end
  end
end
