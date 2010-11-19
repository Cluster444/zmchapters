require 'spec_helper'

describe Page do
  it 'should create a new page' do
    Factory(:page)
  end

  describe 'validations' do
    it 'should reject invalid URIs' do
      ['','a'*101,'f-f','f\'f','f"f','f@f'].each do |bad_uri|
        bad_uri_page = Factory.build(:page, :uri => bad_uri)
        bad_uri_page.should_not be_valid
      end
    end

    it 'should accept valid URIs' do
      good_uri_page = Factory.build(:page, :uri => ('A'..'Z').to_a.join + ('a'..'z').to_a.join + (1..9).to_a.join + '_')
      good_uri_page.should be_valid
    end

    it 'should reject invalid titles' do
      ['','a'*256].each do |bad_title|
        bad_title_page = Factory.build(:page, :title => bad_title)
        bad_title_page.should_not be_valid
      end
    end

    it 'should reject invalid content' do
      ['','a'*8097].each do |bad_content|
        bad_content_page = Factory.build(:page, :content => bad_content)
        bad_content_page.should_not be_valid
      end
    end
  end
end
