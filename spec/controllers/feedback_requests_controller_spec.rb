require 'spec_helper'

describe FeedbackRequestsController do
  def mock_feedback
    @feedback ||= mock_model(FeedbackRequest)
  end

  def create
    post :create, :feedback_request => {"with"=>"params"}
  end
  
  before :each do
    @admin = Factory(:admin)
    sign_in @admin
  end

  describe "GET 'index'" do
    it 'should assign feedback with multiple records' do
      FeedbackRequest.should_receive(:index).and_return([mock_feedback])
      get :index
      assigns[:feedback].should == [mock_feedback]
    end

    it 'should be successful' do
      FeedbackRequest.stub(:index).and_return([mock_feedback])
      get :index
      response.should be_success
    end
  end

  describe "GET 'show'" do
    before :each do
      FeedbackRequest.stub!(:find).and_return(mock_feedback)
    end

    it 'should assign feedback with the selected record' do
      get :show, :id => 1
      assigns[:feedback].should == mock_feedback
    end
      
    it 'should be successful' do
      get :show, :id => 1
      response.should be_success
    end
  end

  describe "GET 'new'" do
    before :each do
      FeedbackRequest.stub!(:new).and_return(mock_feedback)
    end

    it 'should assign feedback with a new record' do
      get :new
      assigns[:feedback].should == mock_feedback
    end

    it 'should be successful' do
      get :new
      response.should be_success
    end
  end

  describe "GET 'edit' " do
    before :each do
      FeedbackRequest.stub!(:find).and_return(mock_feedback)
    end

    it 'should assign feedback with the selected record' do
      get :edit, :id => 1
      assigns[:feedback].should == mock_feedback
    end

    it 'should be successful' do
      get :edit, :id => 1
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before :each do
      FeedbackRequest.stub!(:new).and_return(mock_feedback)
      mock_feedback.stub!(:attributes=)
      mock_feedback.stub!(:save!)
    end

    describe "when signed in" do
      before :each do
        mock_feedback.stub!(:user=)
      end

      it 'should assign feedback with a new record with the given params' do
        FeedbackRequest.should_receive(:new).with({"with"=>"params"}).and_return(mock_feedback)
        create
        assigns[:feedback].should == mock_feedback
      end

      it 'should assign user to the feedback with the current user' do
        mock_feedback.should_receive(:user=).with(@admin)
        create
      end

      it 'should save the feedback' do
        mock_feedback.should_receive(:save!)
        create
      end

      it 'should set a flash notice' do
        create
        flash[:notice].should_not be_nil
      end

      it 'should redirect to the feedback\'s page' do
        create
        response.should redirect_to(feedback_request_path(mock_feedback))
      end

      it 'should render new when validation fails' do
        mock_feedback.stub!(:save!).and_raise(ActiveRecord::RecordInvalid.new(mock_feedback))
        create
        response.should render_template('feedback_requests/new')
      end
    end

    describe "when not signed in" do
      before :each do
        Factory(:site_option, :key => "feedback_status", :value => "public")
        sign_out @admin
      end

      it 'should assign feedback with a new record and the given params' do
        create
        assigns[:feedback].should == mock_feedback
      end

      it 'should save the feedback' do
        mock_feedback.should_receive(:save!)
        create
      end

      it 'should set a flash notice' do
        create
        flash[:notice].should_not be_nil
      end

      it 'should redirect to the home page' do
        create
        response.should redirect_to(home_url)
      end
    end
  end

  describe "PUT 'update'" do
    def update
      put :update, :id => 1, :feedback_request => {"with"=>"params"}
    end

    before :each do
      FeedbackRequest.stub!(:find).and_return(mock_feedback)
      mock_feedback.stub(:update_attributes!)
    end

    it 'should assign feedback with the requested record' do
      FeedbackRequest.should_receive(:find).with(1).and_return(mock_feedback)
      update
      assigns[:feedback].should == mock_feedback
    end

    it 'should update the record with the given params' do
      mock_feedback.should_receive(:update_attributes!).with({"with"=>"params"})
      update
    end

    it 'should set a flash notice' do
      update
      flash[:notice].should_not be_nil
    end

    it 'should redirect to the feedback\'s page' do
      update
      response.should redirect_to(feedback_request_url(mock_feedback))
    end

    it 'should render edit when validation fails' do
      mock_feedback.stub!(:update_attributes!).and_raise(ActiveRecord::RecordInvalid.new(mock_feedback))
      update
      response.should render_template('feedback_requests/edit')
    end
  end
end
