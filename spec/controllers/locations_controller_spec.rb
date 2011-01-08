require 'spec_helper'

describe LocationsController do
  let(:location) { mock_model(Location) }
  let(:parent)   { mock_model(Location, :name => "Parent") }
  let(:map)      { {:lat => 0, :lng => 0, :zoom => 0, :markers => [], :events => false} }
  let(:params)   { Factory.attributes_for(:location).stringify_keys }
  let(:locateable) { mock_model(Chapter) }

  describe 'routing' do
    it { should route(:get,  '/locations/new').to(:action => :new) }
    it { should route(:post, '/locations').to(:action => :create) }
  end

  before :each do
    location.stub(:map_hash) { map }
    User.stub(:new) { mock_model(User, :admin? => true) }
  end

  describe 'GET new' do
    before { Location.should_receive(:new) { location } }
    context 'with a valid parent and locateable' do
      before do
        Chapter.should_receive(:find).with(locateable.id) { locateable }
        Location.should_receive(:find).with(parent.id) { parent }
        location.should_receive(:locateable=).with(locateable)
        parent.should_receive(:map_hash) { map }
        get :new, :parent_id => parent.id, :locateable => {:type => 'Chapter', :id => locateable.id}
      end
      subject { controller }
      it { should assign_to(:parent).with(parent) }
      it { should assign_to(:location).with(location) }
      it { should assign_to(:map).with(map.merge(:events => true)) }
      it { should render_template :new }
      it { should respond_with :success }
    end

    context 'with an invalid parent' do
      before do
        Chapter.should_receive(:find).with(locateable.id) { locateable }
        Location.stub(:find) { record_not_found }
        location.should_receive(:locateable=).with(locateable)
        get :new, :parent_id => parent.id, :locateable => {:type => 'Chapter', :id => locateable.id}
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(root_url) }
    end

    context 'with an invalid locateable' do
      before do
        Chapter.stub(:find) { record_not_found }
        get :new, :parent_id => parent.id, :locateable => {:type => 'Chapter', :id => locateable.id}
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(root_url) }
    end
  end

  describe "POST create" do
    before do
      Location.should_receive(:new) { location }
      location.should_receive(:attributes=).with(params)
    end

    context 'with a valid parent and locateable' do
      before do
        Chapter.should_receive(:find).with(locateable.id) { locateable }
        Location.should_receive(:find).with(parent.id) { parent }
        location.should_receive(:save!)
        location.should_receive(:move_to_child_of).with(parent)
        location.should_receive(:locateable=).with(locateable)
        location.should_receive(:locateable) { locateable }
        post :create, :location => params, :parent_id => parent.id, :locateable => {:type => 'Chapter', :id => locateable.id}
      end
      it { should assign_to(:parent).with(parent) }
      it { should assign_to(:location).with(location) }
      it { should set_the_flash }
      it { should redirect_to(locateable) }
    end

    context 'when validation fails' do
      before do
        Chapter.should_receive(:find).with(locateable.id) { locateable }
        Location.should_receive(:find).with(parent.id) { parent }
        location.stub(:save!) { record_invalid }
        #post :create, :location => params, :parent_id => parent.id, :locateable => {:type => 'Chapter', :id => locateable.id}
      end
    end

    context 'with an invalid parent' do
      before do
        Chapter.should_receive(:find).with(locateable.id) { locateable }
        Location.stub(:find) { record_not_found }
        location.stub(:locateable=).with(locateable)
        post :create, :location => params, :parent_id => parent.id, :locateable => {:type => 'Chapter', :id => locateable.id}
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(root_url) }
    end

    context 'with an invalid locateable' do
      before do
        Chapter.stub(:find) { record_not_found }
        post :create, :location => params, :parent_id => parent.id, :locateable => {:type => 'Chapter', :id => locateable.id}
      end
      subject { controller }
      it { should set_the_flash }
      it { should redirect_to(root_url) }
    end
  end
end
