class Chapter < ActiveRecord::Base
  extend Index
  STATES = %w(pending active inactive)
  CATEGORIES = %w(country state province territory city county university)


  attr_accessible :name, :category

  belongs_to :geographic_location
  has_many :users
  has_many :coordinators
  has_many :links, :as => :linkable
  has_many :events, :as => :plannable
  
  before_create proc { self.status = 'pending' }

  validates :name,     :presence => true, :length => {:maximum => 255}
  validates :category, :presence => true, :length => {:maximum => 255}
  validates :status,   :presence => true, :inclusion => {:in => STATES}, :unless => :new_record?
  validates :geographic_location, :presence => true
  
  def self.find_all_by_location(location)
    ids = location.descendants.collect(&:id)
    where(:geographic_location_id => ids)
  end

  def location
    geographic_location
  end

  def is_pending!
    update_attribute :status, 'pending'
  end

  def is_active!
    update_attribute :status, 'active'
  end

  def is_inactive!
    update_attribute :status, 'inactive'
  end
end
