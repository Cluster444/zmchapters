require 'spec_helper'

describe LinksController do
  let(:link)   { mock_model(Link) }
  let(:links)  { [link] }
  let(:params) { Factory.attributes_for(:link).stringify_keys }
  let(:linkable_params) { {:type => 'Chapter', :id => chapter.id} }
  let(:chapter) { mock_model(Chapter) }

  describe 'routing' do
    it { should route(:get,    '/links').to(       :action => :index)             }
    it { should route(:get,    '/links/1').to(     :action => :show,    :id => 1) }
    it { should route(:get,    '/links/new').to(   :action => :new)               }
    it { should route(:get,    '/links/1/edit').to(:action => :edit,    :id => 1) }
    it { should route(:post,   '/links').to(       :action => :create)            }
    it { should route(:put,    '/links/1').to(     :action => :update,  :id => 1) }
    it { should route(:delete, '/links/1').to(     :action => :destroy, :id => 1) }
  end

  before { User.stub(:new) { mock_model(User, :admin? => true) } }

  describe '#index' do
    before do
      Link.stub_chain(:accessible_by, :search) { links }
      get :index
    end
    subject { controller }
    it { should assign_to(:links).with(links) }
    it { should render_template :index }
    it { should respond_with :success }
  end

  describe '#show' do
    before do
      Link.should_receive(:find).with(link.id) { link }
      get :show, :id => link.id
    end
    subject { controller }
    it { should assign_to(:link).with(link) }
    it { should render_template :show }
    it { should respond_with :success }
  end

  describe '#new' do
    before do
      Link.should_receive(:new) { link }
    end

    context 'when a valid plannable is given' do
      before do
        Chapter.should_receive(:find).with(chapter.id) { chapter }
        link.should_receive(:linkable=).with(chapter)
        post :new, :linkable => linkable_params
      end
      subject { controller }
      it { should assign_to(:link).with(link) }
      it { should render_template :new }
      it { should respond_with :success }
    end

    context 'when an invalid plannable type is given' do
      before do
        post :new, :linkable => {:type => 'NotAModel', :id => 1}
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(Link) }
    end

    context 'when an invalid plannable id is given' do
      before do
        Chapter.stub(:find) { record_not_found }
        post :new, :linkable => linkable_params
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(Link) }
    end
  end

  describe '#edit' do
    before do
      Link.should_receive(:find).with(link.id) { link }
      get :edit, :id => link.id
    end
    subject { controller }
    it { should assign_to(:link).with(link) }
    it { should render_template :edit }
    it { should respond_with :success }
  end

  describe '#create' do
    before do
      Link.should_receive(:new) { link }
      link.should_receive(:attributes=).with(params)
      Chapter.should_receive(:find).with(chapter.id) { chapter }
      link.should_receive(:linkable=).with(chapter)
    end

    context 'when validation passes' do
      before do
        link.should_receive(:save!)
        post :create, :link => params, :linkable => linkable_params
      end
      subject { controller }
      it { should assign_to(:link).with(link) }
      it { should set_the_flash }
      it { should redirect_to(link) }
    end

    context 'when validation fails' do
      before do
        link.stub(:save!) { record_invalid(link) }
        post :create, :link => params, :linkable => linkable_params
      end
      subject { controller }
      it { should assign_to(:link).with(link) }
      it { should render_template :new }
      it { should respond_with :success }
    end
  end

  describe '#update' do
    before do
      Link.should_receive(:find).with(link.id) { link }
    end
    
    context 'when validation passes' do
      before do
        link.stub(:update_attributes!)
        put :update, :id => link.id, :link => params
      end
      subject { controller }
      it { should assign_to(:link).with(link) }
      it { should set_the_flash }
      it { should redirect_to(link) }
    end

    context 'when validation fails' do
      before do
        link.stub(:update_attributes!) { record_invalid(link) }
        put :update, :id => link.id, :link => params
      end
      subject { controller }
      it { should assign_to(:link).with(link) }
      it { should render_template :edit }
      it { should respond_with :success }
    end
  end

  describe '#destroy' do
    before do
      Link.should_receive(:find).with(link.id) { link }
      link.should_receive(:destroy)
      delete :destroy, :id => link.id
    end
    subject { controller }
    it { should assign_to(:link).with(link) }
    it { should set_the_flash }
    it { should redirect_to(Link) }
  end
end
