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

  def mock_chapter
    @chapter ||= mock_model(Chapter)
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

    it 'should save the record' do
      mock_user.should_receive(:save!)
      create
    end

    it 'should set a flash notice' do
      create
      flash[:notice].should_not be_nil
    end

    it 'should redirect to the user\'s page when an admin creates the user' do
      create
      response.should redirect_to(mock_user)
    end

    it 'should redirect to the login page when a guest creates a user' do
      sign_out @admin
      create
      response.should redirect_to(new_user_session_path)
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

  describe "PUT #join_chapter" do
    before  { User.should_receive(:find).twice { mock_user } }
    before  { Chapter.should_receive(:find).with(2) { mock_chapter } }
    before  { mock_chapter.stub :name }
    before  { mock_user.should_receive(:update_attribute).with(:chapter, mock_chapter) }
    before  { put :join_chapter, :id => 1, :chapter_id => 2 }
    subject { controller }
    it { should set_the_flash }
    it { should redirect_to(chapter_url(mock_chapter)) }

    describe 'when the chapter does not exist' do
      before  { Chapter.stub(:find) { raise ActiveRecord::RecordNotFound } }
      before  { put :join_chapter, :id => 1, :chapter_id => 2 }
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(chapters_url) }
    end
  end
end
