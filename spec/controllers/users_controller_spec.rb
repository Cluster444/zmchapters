require 'spec_helper'

describe UsersController do
  let(:chapter) { mock_model(Chapter) }
  let(:params)  { Factory.attributes_for(:user) }

  def mock_user(stubs={})
    user
  end

  def mock_chapter
    chapter
  end
  
  def record_invalid; raise ActiveRecord::RecordInvalid.new(user); end
  
  before :all do
    User.destroy_all
    @admin = Factory(:admin)
  end

  before :each do
    sign_in @admin
  end

  describe "GET index" do
    before  { get :index }
    subject { controller }
    it { should assign_to(:users).with([@admin]) }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe 'GET show' do
    before  { get :show, :id => @admin.id }
    subject { controller }
    it { should assign_to(:user).with(@admin) }
    it { should render_template :show }
    it { should respond_with :success }
  end

  describe 'GET new' do
    before  { get :new }
    subject { controller }
    it { should assign_to(:user) }
    it { should render_template :new }
    it { should respond_with :success }
  end

  describe 'GET edit' do
    before  { get :edit, :id => @admin.id }
    subject { controller }
    it { should assign_to(:user).with(@admin) }
    it { should render_template :edit }
    it { should respond_with :success }
  end

  describe 'POST create' do
    def create(opts={})
      post :create, opts.merge(:user => params)
    end
    
    context 'when validation passes' do
      context 'and the user is signed in' do
        before  { create }
        subject { controller }
        it { should assign_to(:user) }
        it { should set_the_flash }
        it { should redirect_to(user_path(User.last)) }
      end

      context 'and the user is not signed in' do
        before  do
          sign_out @admin
          create
        end
        subject { controller }
        it { should assign_to(:user) }
        it { should set_the_flash }
        it { should redirect_to(new_user_session_url) }
      end
    end
    
    context 'when validation fails' do
      before  { post :create, :user => nil }
      subject { controller }
      it { should assign_to(:user) }
      it { should render_template :new }
      it { should respond_with :success }
    end
  end

  describe 'PUT update' do
    def update(opts={})
      put :update, opts.merge(:id => @admin.id, :user => params)
    end
    
    context 'when validation passes' do
      before  { update }
      subject { controller }
      it { should assign_to(:user).with(@admin) }
      it { should set_the_flash }
      it { should redirect_to(@admin) }
    end

    context 'when validation fails' do
      before  { @admin.stub(:update_attributes!) { raise 'wtf' } }
      before  { put :update, :id => @admin.id, :user => {:name => 'a'*51} }
      subject { controller }
      it { should assign_to(:user).with(@admin) }
      it { should render_template :edit }
      it { should respond_with :success }
    end
  end

  describe "PUT #join_chapter" do
    context 'when the chapter exists' do
      before do
        Chapter.stub :find => chapter
        chapter.stub :name => 'ChapterName'
        put :join_chapter, :id => @admin.id, :chapter_id => chapter.id
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(chapter_url(chapter)) }
    end

    context 'wehn the chapter does not exist' do
      before do
        Chapter.stub(:find) { raise ActiveRecord::RecordNotFound }
        put :join_chapter, :id => @admin.id, :chapter_id => 0
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(Chapter) }
    end
  end
end
