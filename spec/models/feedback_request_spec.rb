require 'spec_helper'

describe FeedbackRequest do
  def create(options={})
    Factory.create(:feedback_request, options)
  end

  def build(options={})
    Factory.build(:feedback_request, options)
  end
  
  describe 'factories' do
    it { expect { Factory.create(:feedback_request) }.to change { FeedbackRequest.count }.by(1) }
  end
  
  # Mass Assignment
  it { should allow_mass_assignment_of :email }
  it { should allow_mass_assignment_of :subject }
  it { should allow_mass_assignment_of :message }
  it { should allow_mass_assignment_of :category }

  it { should_not allow_mass_assignment_of :status }
  it { should_not allow_mass_assignment_of :user_id }

  # Associations
  it { should belong_to :user }

  # Validations
  it { should validate_presence_of :email }
  it { should validate_presence_of :subject }
  it { should validate_presence_of :message }
  it { should validate_presence_of :category }

  it { should ensure_length_of(:email).is_at_most(255) }
  it { should ensure_length_of(:subject).is_at_most(255) }
  it { should ensure_length_of(:message).is_at_most(4096) }
  
  it { should allow_value('bug').for(:category) }
  it { should allow_value('feature').for(:category) }

  it { should allow_value('new').for(:status) }
  it { should allow_value('acknowledged').for(:status) }
  it { should allow_value('resolved').for(:status) }
  it { should allow_value('closed').for(:status) }
  it { should allow_value('rejected').for(:status) }

  context 'validation with a user' do
    subject { Factory.build(:feedback_request, :user => mock_model(User), :email => nil) }
    it { should be_valid }
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
    
    subject { FeedbackRequest }
    its(:new_requests) { should == [@scope[:new]] }
    its(:acknowledged) { should == [@scope[:acknowledge]] }
    its(:resolved)     { should == [@scope[:resolve]] }
    its(:closed)       { should == [@scope[:close]] }
    its(:rejected)     { should == [@scope[:reject]] }
  end
end
