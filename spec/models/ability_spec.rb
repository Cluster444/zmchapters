require 'spec_helper'

RSpec::Matchers.define :be_able_to do |*args|
  @args = args

  def description
    "be able to #{@args.first.to_s} #{@args.last.to_s}"
  end

  match do |ability|
    ability.can?(*args)
  end

  failure_message_for_should do |ability|
    "expected to be able to #{args.map(&:inspect).join(" ")}"
  end

  failure_message_for_should_not do |ability|
    "expected to not be able to #{args.map(&:inspect).join(" ")}"
  end
end

describe 'Ability' do
  let(:user)        { mock_model(User) }
  let(:site_option) { mock_model(SiteOption) }
  let(:feedback)    { mock_model(Feedback) }
  let(:chapter)     { mock_model(Chapter) }
  let(:link)        { mock_model(Link) }
  let(:task)        { mock_model(Task) }
  let(:coordinator) { mock_model(Coordinator) }
  let(:event)       { mock_model(Event) }

  def ability
    Ability.new(user)
  end

  before :each do
    SiteOption.stub  :find_by_key  => site_option
    site_option.stub :value        => nil
    user.stub        :admin?       => false
    user.stub        :coordinator? => false
    user.stub        :new_record?  => true
    feedback.stub    :user_id      => user.id
  end

  describe 'when user is an admin' do
    before  { user.stub :admin? => true }
    subject { ability }
    it      { should be_able_to(:manage, :all) }
  end

  describe 'when user is a coordinator' do
    before do
      user.stub :new_record? => false
      user.stub :coordinator? => true
      Coordinator.should_receive(:find_by_user_id).with(user.id) { coordinator }
      coordinator.stub :chapter => chapter
      link.stub :linkable => chapter
      task.stub :taskable => chapter
      event.stub :plannable => chapter
    end
    subject { Ability.new(user) }
    it { should be_able_to(:manage, link) }
    it { should be_able_to(:manage, task) }
    it { should be_able_to(:manage, event) }
    it { should be_able_to(:create, Feedback) }
  end

  describe 'when user is a member' do
    before  { user.stub :new_record? => false }
    before  { user.stub :to_ary }
    before  { feedback.stub :user_id => user.id }
    subject { ability }
    it { should be_able_to(:read, Chapter) }
    it { should be_able_to(:read, Coordinator) }
    it { should be_able_to(:read, Event) }
    it { should be_able_to(:read, Location) }
    it { should be_able_to(:read, Link) }
    it { should be_able_to(:read, Page) }
    it { should be_able_to(:read, User) }
    it { should be_able_to(:read, Task) }
    it { should be_able_to(:read, feedback) }
    it { should be_able_to(:update, user) }
    it { should be_able_to(:join_chapter, user) }

    it { should_not be_able_to(:read, SiteOption) }
    it { should_not be_able_to(:create, User) }
    it { should_not be_able_to(:read, mock_model(Feedback, :user_id => (user.id+1))) }
    it { should_not be_able_to(:update, mock_model(User)) }

    describe 'and feedback is open' do
      before { site_option.stub :value => 'open' }
      subject { ability }
      it { should be_able_to(:create, Feedback) }
    end
  end

  describe 'when user is a guest' do
    subject { ability }
    it { should be_able_to(:read, Chapter) }
    it { should be_able_to(:read, Coordinator) }
    it { should be_able_to(:read, Event) }
    it { should be_able_to(:read, Location) }
    it { should be_able_to(:read, Link) }
    it { should be_able_to(:read, Page) }
    it { should be_able_to(:read, User) }

    it { should_not be_able_to(:read, SiteOption) }

    describe 'and registration is open' do
      before  { site_option.stub :value => 'open' }
      subject { ability }
      it      { should be_able_to(:create, User) }
    end

    describe 'and feedback is open to public' do
      before  { site_option.stub :value => 'public' }
      subject { ability }
      it      { should be_able_to(:create, Feedback) }
    end
  end
end
