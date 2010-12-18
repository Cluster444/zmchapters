require 'spec_helper'

describe LinksController do
  let(:link)   { mock_model(Link) }
  let(:links)  { [link] }
  let(:params) { Factory.attributes_for(:link).stringify_keys }

  before { User.stub(:new) { mock_model(User, :admin? => true) } }

  describe '#index' do
    before do
      Link.should_receive(:search) { links }
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
      get :new
    end
    subject { controller }
    it { should assign_to(:link).with(link) }
    it { should render_template :new }
    it { should respond_with :success }
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
    end

    context 'when validation passes' do
      before do
        link.should_receive(:save!)
        post :create, :link => params
      end
      subject { controller }
      it { should assign_to(:link).with(link) }
      it { should set_the_flash }
      it { should redirect_to(link) }
    end

    context 'when validation fails' do
      before do
        link.stub(:save!) { record_invalid(link) }
        post :create, :link => params
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
