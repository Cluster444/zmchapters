class Chapter < ActiveRecord::Base
  attr_accessible :region, :description

  has_and_belongs_to_many :country
  has_many :users
  has_many :external_urls

  default_scope order('region')

  def hyperlinks
    external_urls.where("type = 'hyperlink'")
  end

  def self.search(search, page, options = {})
    paginate :per_page => 20, :page => page,
             :conditions => ['region like ?', "#{search}"],
             :order => 'region'
  end
end
