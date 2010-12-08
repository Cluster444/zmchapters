require 'spec_helper'

describe CoordinatorsController do
  def mock_coordinator(stubs={})
    (@mock_coordinator ||= mock_model(Coordinator).as_null_object).tap do |coordinator|
      coordinator.stub(stubs) unless stubs.empty?
    end
  end

  before :each do
    User.stub(:new) { mock_model(User, :admin? => true) }
  end

  describe "GET new" do
    before :each do
      Coordinator.stub!(:new).and_return(mock_coordinator)
    end

    it 'assigns coordinator with a new record' do
      get :new
      assigns[:coordinator].should == mock_coordinator
    end

    it 'should be successful' do
      get :new
      response.should be_success
    end
  end

  describe "POST create" do
    def create
      post :create, :coordinator => {"with"=>"params"}
    end

    before :each do
      Coordinator.stub(:new) { mock_coordinator }
      mock_coordinator.stub(:save!)
    end
    
    it 'assigns coordinator with a new record' do
      Coordinator.should_receive(:new).with({"with"=>"params"}) { mock_coordinator(:save!) }
      create
      assigns[:coordinator].should == mock_coordinator
    end

    it 'should save the record' do
      mock_coordinator.should_receive(:save!)
      create
    end

    it 'should set a flash notice' do
      create
      flash[:notice].should_not be_nil
    end

    it 'should redirect to the user page of the new coordinator' do
      mock_coordinator(:user => @admin)
      create
      response.should redirect_to(users_path(@admin))
    end

    it 'should render new when validation fails' do
      mock_coordinator.stub(:save!) { raise ActiveRecord::RecordInvalid.new(mock_coordinator) }
      create
      response.should render_template('coordinators/new')
    end
  end
end
