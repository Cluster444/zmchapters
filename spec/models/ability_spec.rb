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
  def mock_user
    @user ||= mock_model(User)
  end

  def mock_site_option
    @option ||= mock_model(SiteOption)
  end

  def mock_feedback
    @feedback ||= mock_model(FeedbackRequest)
  end

  def ability
    Ability.new(mock_user)
  end

  before :each do
    SiteOption.stub       :find_by_key => mock_site_option
    mock_site_option.stub :value       => nil
    mock_user.stub        :admin?      => false
    mock_user.stub        :new_record? => true
    mock_feedback.stub    :user_id     => mock_model(User).id
  end

  describe 'when user is an admin' do
    before  { mock_user.stub :admin? => true }
    subject { ability }
    it      { should be_able_to(:manage, :all) }
  end

  describe 'when user is a member' do
    before  { mock_user.stub :new_record? => false }
    before  { mock_user.stub :to_ary }
    before  { mock_feedback.stub :user_id => mock_user.id }
    subject { ability }
    it { should be_able_to(:read, Chapter) }
    it { should be_able_to(:read, Coordinator) }
    it { should be_able_to(:read, Event) }
    it { should be_able_to(:read, GeographicLocation) }
    it { should be_able_to(:read, Link) }
    it { should be_able_to(:read, Page) }
    it { should be_able_to(:read, User) }
    it { should be_able_to(:read, mock_feedback) }
    it { should be_able_to(:update, mock_user) }

    it { should_not be_able_to(:read, SiteOption) }
    it { should_not be_able_to(:create, User) }
    it { should_not be_able_to(:read, mock_model(FeedbackRequest).stub(:user_id) { nil } ) }
    it { should_not be_able_to(:update, mock_model(User)) }

    describe 'and feedback is open' do
      before { mock_site_option.stub :value => 'open' }
      subject { ability }
      it { should be_able_to(:create, FeedbackRequest) }
    end
  end

  describe 'when user is a guest' do
    subject { ability }
    it { should be_able_to(:read, Chapter) }
    it { should be_able_to(:read, Coordinator) }
    it { should be_able_to(:read, Event) }
    it { should be_able_to(:read, GeographicLocation) }
    it { should be_able_to(:read, Link) }
    it { should be_able_to(:read, Page) }
    it { should be_able_to(:read, User) }

    it { should_not be_able_to(:read, SiteOption) }

    describe 'and registration is open' do
      before  { mock_site_option.stub :value => 'open' }
      subject { ability }
      it      { should be_able_to(:create, User) }
    end

    describe 'and feedback is open to public' do
      before  { mock_site_option.stub :value => 'public' }
      subject { ability }
      it      { should be_able_to(:create, FeedbackRequest) }
    end
  end
end
