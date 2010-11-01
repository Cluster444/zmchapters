class Chapter < ActiveRecord::Base
  attr_accessible :name, :description, :geographic_location_id
  
  belongs_to :geographic_location
  has_many :users
  has_many :external_urls

  default_scope order('name')

  TYPES=%w(state province territory city county university college)

  def hyperlinks
    external_urls.where("type = 'hyperlink'")
  end

  def self.search(search, page, options = {})
    paginate :per_page => 20, :page => page,
             :conditions => ['name like ?', "#{search}"],
             :order => 'name'
  end
end
