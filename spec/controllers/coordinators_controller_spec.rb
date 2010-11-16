require 'spec_helper'

describe CoordinatorsController do
  
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
      Coordinator.stub(:all) { [mock_coordinator] }
      get :index, :chapter_id => @chapter.id
      assigns(:coordinators).should eq([mock_coordinator])
    end
  end

  describe "GET new" do
    it "assigns a new coordinator as @coordinator" do
      Coordinator.stub(:new) { mock_coordinator }
      get :new, :chapter_id => @chapter.id
      assigns(:coordinator).should be(mock_coordinator)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created coordinator as @coordinator" do
        Coordinator.stub(:new).with({'these' => 'params', 'chapter_id' => @chapter.id}) { mock_coordinator(:save => true) }
        post :create, :chapter_id => @chapter.id, :coordinator => {'these' => 'params'}
        assigns(:coordinator).should be(mock_coordinator)
      end

      it "redirects to the chapter page" do
        Coordinator.stub(:new) { mock_coordinator(:save => true) }
        post :create, :chapter_id => @chapter.id, :coordinator => {}
        response.should redirect_to(chapter_url(@chapter))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved coordinator as @coordinator" do
        Coordinator.stub(:new).with({'these' => 'params', 'chapter_id' => @chapter.id}) { mock_coordinator(:save => false) }
        post :create, :chapter_id => @chapter.id, :coordinator => {'these' => 'params'}
        assigns(:coordinator).should be(mock_coordinator)
      end

      it "re-renders the 'new' template" do
        Coordinator.stub(:new) { mock_coordinator(:save => false) }
        post :create, :chapter_id => @chapter.id, :coordinator => {}
        response.should render_template("new")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested coordinator" do
      Coordinator.should_receive(:find).with("37") { mock_coordinator }
      mock_coordinator.should_receive(:destroy)
      delete :destroy, :chapter_id => @chapter.id, :id => "37"
    end

    it "redirects to the coordinators list" do
      Coordinator.stub(:find) { mock_coordinator }
      delete :destroy, :chapter_id => @chapter.id, :id => "1"
      response.should redirect_to(chapter_url(@chapter))
    end
  end

end
