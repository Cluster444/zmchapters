class Chapter < ActiveRecord::Base
  attr_accessible :region, :description

  has_and_belongs_to_many :country
  has_many :members

  default_scope order('region')

  def self.search(search, page, options = {})
    paginate :per_page => 20, :page => page,
             :conditions => ['region like ?', "#{search}%"],
             :order => 'region'
  end
end
