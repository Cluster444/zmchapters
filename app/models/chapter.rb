class Chapter < ActiveRecord::Base
  attr_accessible :name, :description, :geographic_territory_id
  
  belongs_to :geographic_territory
  has_many :users
  has_many :external_urls

  default_scope order('name')

  def hyperlinks
    external_urls.where("type = 'hyperlink'")
  end

  def self.search(search, page, options = {})
    paginate :per_page => 20, :page => page,
             :conditions => ['name like ?', "#{search}"],
             :order => 'name'
  end
end
