require 'spec_helper'

describe FeedbackRequest do
  def create(options={})
    Factory.create(:feedback_request, options)
  end

  def build(options={})
    Factory.build(:feedback_request, options)
  end

  it 'should have a factory' do
    Factory.create(:feedback_request)
  end

  describe 'validations' do
    it 'should reject invalid emails' do
      ['','a'*256].each do |invalid_email|
        build(:email => invalid_email).should_not be_valid
      end
    end

    it 'should disregard email when a user is supplied' do
      user = Factory(:user)
      feedback = build(:email => '', :user => user)
      feedback.should be_valid
    end

    it 'should reject invalid subjects' do
      ['','a'*256].each do |invalid_subject|
        build(:subject => invalid_subject).should_not be_valid
      end
    end

    it 'should reject invalid messages' do
      ['','a'*4097].each do |invalid_message|
        build(:message => invalid_message).should_not be_valid
      end
    end

    it 'should reject invalid categories' do
      ['', 'invalid_category'].each do |invalid_category|
        build(:category => invalid_category).should_not be_valid
      end
    end

    it 'should accept all valid categories' do
      FeedbackRequest::CATEGORIES.each do |category|
        build(:category => category).should be_valid
      end
    end
  end

  describe 'status' do
    it 'should mark all new records with a state of new' do
      feedback = create
      feedback.should be_new
    end

    it 'should allow the request be acknowledged' do
      feedback = create
      feedback.acknowledge!
      feedback.reload
      feedback.should be_acknowledged
    end

    it 'should allow the request be resolved' do
      feedback = create
      feedback.resolve!
      feedback.reload
      feedback.should be_resolved
    end

    it 'should allow the request be closed' do
      feedback = create
      feedback.close!
      feedback.reload
      feedback.should be_closed
    end

    it 'should allow the request be rejected' do
      feedback = create
      feedback.reject!
      feedback.reload
      feedback.should be_rejected
    end
  end

  describe 'scopes' do
    before :each do
      @scope = {:new => create}
      ['acknowledge','resolve','close','reject'].each do |state|
        @scope[:"#{state}"] = create
        @scope[:"#{state}"].send("#{state}!")
      end
    end

    it 'should provide a scope for new requests' do
      FeedbackRequest.new_requests.should == [@scope[:new]]
    end

    it 'should provide a scope for acknowledged requests' do
      FeedbackRequest.acknowledged.should == [@scope[:acknowledge]]
    end

    it 'should provide a scope for resolved requests' do
      FeedbackRequest.resolved.should == [@scope[:resolve]]
    end

    it 'should provide a scope for closed requests' do
      FeedbackRequest.closed.should == [@scope[:close]]
    end

    it 'should provide a scope for rejected requests' do
      FeedbackRequest.rejected.should == [@scope[:reject]]
    end
  end
end
