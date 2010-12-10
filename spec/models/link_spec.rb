require 'spec_helper'

describe Link do
  def build(opts={})
    Factory.build(:link, opts)
  end

  it 'should have a factory' do
    Factory.create(:link)
  end

  describe 'validations' do
    it 'should reject invalid urls' do
      ['','a'*256].each do |invalid_url|
        build(:url => invalid_url).should_not be_valid
      end
    end

    it 'should reject invalid titles' do
      ['','a'*256].each do |invalid_title|
        build(:title => invalid_title).should_not be_valid
      end
    end

    it 'should require an linkable association' do
      build(:linkable => nil).should_not be_valid
    end
  end
end
