require 'spec_helper'

describe UsersController do
  
  def do_create
    post :create, :user => {:name=>"value"}
  end

  def do_update
    post :update, :id => 1, :user => {:name=>"value"}
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  before :each do
    mock_user
  end

  describe "GET index" do
    it 'assigns all users as @users' do
      @users = (1..5).collect {Factory :user}
      User.should_receive(:all).once.and_return(@users)
      get :index
      assigns[:users].should == @users
    end
  end

  describe "GET show" do
    describe "for a record that exists" do
      it 'should assign @user from the id' do
        User.should_receive(:find).with(1).once.and_return(@mock_user)
        get :show, :id => 1
        assigns[:user].should == @mock_user
      end
    end

    describe "for a record that does not exist" do
      it 'should redirect to the index with a flash error' do
        User.should_receive(:find).with(1).once.and_raise(ActiveRecord::RecordNotFound)
        get :show, :id => 1
        response.should redirect_to users_url
        flash[:error].should_not be_nil
      end
    end
  end

  describe "GET new" do
    it 'should assign a new chapter to @chapter' do
      User.should_receive(:new).and_return(@mock_user)
      get :new
      assigns[:user].should == @mock_user
    end
  end

  describe "GET edit" do
    describe "for a record that exists" do
      it 'should assign @user from the id' do
        User.should_receive(:find).with(1).and_return(@mock_user)
        get :edit, :id => 1
        assigns[:user].should == @mock_user
      end
    end

    describe "for a record that does not exist" do
      it 'should redirect to the index with a flash error' do
        User.should_receive(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
        get :edit, :id => 1
        response.should redirect_to users_url
        flash[:error].should_not be_nil
      end
    end
  end

  describe "POST create" do
    before :each do
      User.stub!(:new).with("name"=>"value").and_return(@mock_user)
      @mock_user.stub!(:save!)
    end

    it 'should assign a new user with the given params' do
      User.should_receive(:new).with("name"=>"value").and_return(@mock_user)
      do_create
      assigns[:user].should == @mock_user
    end
      
    it 'should save the user' do
      @mock_user.should_receive(:save!)
      do_create
    end

    describe "with valid params" do
      it 'should redirect to index with a flash success' do
        do_create
        response.should redirect_to user_url(@mock_user)
        flash[:success].should_not be_nil
      end
    end

    describe "with invalid params" do
      it 'should render new' do
        @mock_user.stub!(:save!).and_raise(ActiveRecord::RecordInvalid.new(@mock_user))
        do_create
        response.should render_template 'users/new'
      end
    end
  end

  describe "PUT update" do
    describe "for a record that exists" do
      before :each do
        User.stub!(:find).with(1).and_return(@mock_user)
        @mock_user.stub!(:update_attributes!).with("name"=>"value")
      end

      it 'should assign @user from the given id' do
        User.should_receive(:find).with(1).and_return(@mock_user)
        do_update
        assigns[:user].should == @mock_user
      end

      it 'should update the attributes' do
        @mock_user.should_receive(:update_attributes!).with("name"=>"value")
        do_update
      end

      describe "with valid params" do
        it 'should redirect to show with a flash success' do
          do_update
          response.should redirect_to user_url(@mock_user)
          flash[:success].should_not be_nil
        end
      end

      describe "with invalid params" do
        it 'should render edit' do
          @mock_user.stub!(:update_attributes!).with("name"=>"value").and_raise(ActiveRecord::RecordInvalid.new(@mock_user))
          do_update
          response.should render_template 'users/edit'
        end
      end
    end

    describe "for a record that does not exist" do
      it 'should redirect to index with flash error' do
        User.stub!(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
        do_update
        response.should redirect_to users_url
        flash[:error].should_not be_nil
      end
    end
  end

  describe "DELETE destroy" do
    describe "for a record that exists" do
      it 'should redirect to index with a flash success' do
        User.stub!(:find).with(1).and_return(@mock_user)
        @mock_user.should_receive(:destroy)
        delete :destroy, :id => 1
      end
    end

    describe "for a record that does not exist" do
      it 'should redirect to index with a flash error' do
        User.stub!(:find).with(1).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, :id => 1
        response.should redirect_to users_url
        flash[:error].should_not be_nil
      end
    end
  end
end
