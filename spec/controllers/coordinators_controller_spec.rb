require 'spec_helper'

describe CoordinatorsController do
  let (:coordinator) { mock_model(Coordinator) }
  let (:chapter)     { mock_model(Chapter) }
  let (:user)        { mock_model(User) }
  
  def record_invalid; raise ActiveRecord::RecordInvalid.new(coordinator); end
  def create; post :create, :coordinator => params; end
  def params; {"user_id" => user.id, "chapter_id" => chapter.id}; end

  before { User.stub(:new) { mock_model(User, :admin? => true) } }

  describe "GET new" do
    before  { Coordinator.should_receive(:new) { coordinator } }
    before  { get :new }

    subject { controller }
    it { should assign_to(:coordinator).with(coordinator) }
    it { should respond_with :success }
  end

  describe "POST create" do
    before do
      User.should_receive(:find_by_id).with(user.id) { user }
      Chapter.should_receive(:find_by_id).with(chapter.id) { chapter }
      Coordinator.should_receive(:new) { coordinator }
      coordinator.should_receive(:attributes=).with(params)
      coordinator.should_receive(:user=).with(user)
      coordinator.should_receive(:chapter=).with(chapter)
      coordinator.stub(:chapter => chapter)
    end

    context 'before validation' do
      before  { coordinator.should_receive(:save!) }
      before  { create }
      subject { controller }
      it { should assign_to(:coordinator).with(coordinator) }
    end
    
    context 'when validation passes' do
      before  { coordinator.should_receive(:save!) }
      before { create }
      subject { controller }
      it { should redirect_to(chapter_path(chapter)) }
      it { should set_the_flash }
    end

    context 'when validation fails' do
      before { coordinator.stub(:save!) { record_invalid } }
      before { create }
      subject { controller }
      it { should render_template :new }
    end
  end
end
