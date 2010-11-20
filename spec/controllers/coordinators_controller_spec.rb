require 'spec_helper'

describe CoordinatorsController do
  include Devise::TestHelpers

  before :all do
    @chapter = Factory(:chapter)
  end

  def mock_coordinator(stubs={})
    (@mock_coordinator ||= mock_model(Coordinator).as_null_object).tap do |coordinator|
      coordinator.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all coordinators as @coordinators" do
      pending
      #Coordinator.stub(:all) { [mock_coordinator] }
      #get :index
      #assigns(:coordinators).should eq([mock_coordinator])
    end
  end

  describe "GET new" do
    it "assigns a new coordinator as @coordinator" do
      new_coordinator = Coordinator.new
      Coordinator.stub(:new) { new_coordinator }
      get :new
      assigns[:coordinator].should be(new_coordinator)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created coordinator as @coordinator" do
        Coordinator.stub(:new) { mock_coordinator(:save => true) }
        post :create, :coordinator => {'these' => 'params'}
        assigns(:coordinator).should be(mock_coordinator)
      end

      it "redirects to the chapter page" do
        pending
        #Coordinator.stub(:new) { mock_coordinator(:save => true) }
        #post :create, :coordinator => {}
        #response.should redirect_to()
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved coordinator as @coordinator" do
        Coordinator.stub(:new) { mock_coordinator(:save => false) }
        post :create, :coordinator => {'these' => 'params'}
        assigns[:coordinator].should be(mock_coordinator)
      end

      it "re-renders the 'new' template" do
        Coordinator.stub(:new) { mock_coordinator(:save => false) }
        post :create, :coordinator => {}
        response.should render_template("new")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested coordinator" do
      pending
      #Coordinator.should_receive(:find).with("37") { mock_coordinator }
      #mock_coordinator.should_receive(:destroy)
      #delete :destroy, :id => "37"
    end

    it "redirects to the coordinators list" do
      pending
      #Coordinator.stub(:find) { mock_coordinator }
      #delete :destroy, :id => "1"
      #response.should redirect_to
    end
  end

end
