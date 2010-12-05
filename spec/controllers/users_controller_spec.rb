require 'spec_helper'

describe UsersController do
  def params
    {"with"=>"params"}
  end

  def mock_user(stubs={})
    (@user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end
  
  def invalid
    raise ActiveRecord::RecordInvalid.new(mock_user)
  end

  before :each do
    @admin = Factory(:admin)
    sign_in @admin
  end

  describe "GET index" do
    it 'should assign users with the records for the given params' do
      User.should_receive(:index) { [mock_user] }
      get :index
      assigns[:users].should == [mock_user]
    end

    it 'should be successful' do
      User.stub(:index) { [mock_user] }
      get :index
      response.should be_success
    end
  end

  describe 'GET show' do
    before :each do
      User.stub(:find) { mock_user }
    end

    it 'should assign user with the requested record' do
      get :show, :id => 1
      assigns[:user].should == mock_user
    end

    it 'should be successful' do
      get :show, :id => 1
      response.should be_success
    end
  end

  describe 'GET new' do
    before :each do
      User.stub(:new) { mock_user }
    end

    it 'should assign user with a new record' do
      get :new
      assigns[:user].should == mock_user
    end

    it 'should be successful' do
      get :new
      response.should be_success
    end
  end

  describe 'GET edit' do
    before :each do
      User.stub(:find) { mock_user }
    end

    it 'should assign user with the requested record' do
      get :edit, :id => 1
      assigns[:user].should == mock_user
    end

    it 'should be successful' do
      get :edit, :id => 1
      response.should be_success
    end
  end

  describe 'POST create' do
    def create(opts={})
      opts[:user] = params
      post :create, opts
    end

    def mock_location
      @location ||= mock_model(GeographicLocation)
    end

    before :each do
      User.stub(:new) { mock_user }
      mock_user.stub(:attributes=)
      mock_user.stub(:save!)
    end

    it 'should assign user with a new record and the given params' do
      User.should_receive(:new) { mock_user }
      mock_user.should_receive(:attributes=).with(params)
      create
      assigns[:user].should == mock_user
    end

    it 'should set the users location if one was given' do
      GeographicLocation.should_receive(:find_by_id).with(1) { mock_location }
      mock_user.should_receive(:geographic_location=).with(mock_location)
      create :location_id => 1
    end

    it 'should save the record' do
      mock_user.should_receive(:save!)
      create
    end

    it 'should set a flash notice' do
      create
      flash[:notice].should_not be_nil
    end

    it 'should redirect to the user\'s page' do
      create
      response.should redirect_to(mock_user)
    end

    it 'should render new when validatoion fails' do
      mock_user.stub(:save!) { invalid }
      create
      response.should render_template('users/new')
    end
  end

  describe 'PUT update' do
    def update(opts={})
      put :update, opts.merge(:id => 1, :user => params)
    end

    before :each do
      User.stub(:find) { mock_user }
      mock_user.stub(:update_attributes!)
    end

    it 'should assign user with the requested record' do
      update
      assigns[:user].should == mock_user
    end
    
    it 'should update the record with the given params' do
      mock_user.should_receive(:update_attributes!).with(params)
      update
    end

    describe 'chapter update' do
      def mock_chapter
        @chapter ||= mock_model(Chapter)
      end

      def mock_location
        @location ||= mock_model(GeographicLocation)
      end

      before :each do
        mock_user.stub(:update_attribute)
        Chapter.stub(:find) { mock_chapter }
        mock_chapter.stub(:geographic_location) { mock_location }
      end

      it 'should update the user\'s chapter' do
        mock_user.should_receive(:update_attribute).with(:chapter, mock_chapter)
        update :chapter_id => mock_chapter.id
      end

      it 'should update the user\'s location' do
        mock_user.should_receive(:update_attribute).with(:geographic_location, mock_location)
        update :chapter_id => mock_chapter.id
      end

      it 'should render edit if the chapter does not exist' do
        Chapter.stub(:find) { raise ActiveRecord::RecordNotFound }
        update :chapter_id => mock_chapter.id
        response.should render_template('users/edit')
      end
    end

    it 'should set a flash notice' do
      update
      flash[:notice].should_not be_nil
    end

    it 'should redirect to the user\'s page' do
      update
      response.should redirect_to(mock_user)
    end

    it 'should render edit when validation fails' do
      mock_user.stub(:update_attributes!) { invalid }
      update
      response.should render_template('users/edit')
    end
  end
end
