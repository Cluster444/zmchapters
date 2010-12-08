require 'spec_helper'

describe CoordinatorsController do
  def mock_coordinator
    @coordinator ||= mock_model(Coordinator)
  end

  def mock_chapter
    @chapter ||= mock_model(Chapter)
  end

  def record_invalid
    raise ActiveRecord::RecordInvalid.new(mock_coordinator)
  end

  before :each do
    User.stub(:new) { mock_model(User, :admin? => true) }
  end

  describe "GET new" do
    before :each do
      Coordinator.stub! :new => mock_coordinator
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
      Coordinator.stub :new => mock_coordinator
      mock_coordinator.stub :attributes=
      mock_coordinator.stub :save!
      mock_coordinator.stub :chapter => mock_chapter
    end
    
    it 'assigns coordinator with a new record' do
      Coordinator.should_receive(:new) { mock_coordinator }
      mock_coordinator.should_receive(:attributes=).with({"with"=>"params"})
      create
      assigns[:coordinator].should == mock_coordinator
    end

    it 'should save the record' do
      mock_coordinator.should_receive(:save!)
      create
    end

    it 'should redirect to the chapter page of the new coordinator with a flash notice' do
      mock_coordinator.should_receive(:chapter) { mock_chapter }
      create
      response.should redirect_to(chapter_path(mock_chapter))
      flash[:notice].should_not be_nil
    end

    it 'should render new when validation fails' do
      mock_coordinator.stub(:save!) { record_invalid }
      create
      response.should render_template('coordinators/new')
    end
  end
end
