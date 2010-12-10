class Chapter < ActiveRecord::Base
  extend Index

  STATES = %w(pending active inactive)
  CATEGORIES = %w(country state province territory city county university)

  belongs_to :geographic_location
  has_many :users
  has_many :coordinators
  has_many :links, :as => :linkable
  
  before_create :pending!

  validates :name,     :presence => true, :length => {:maximum => 100}
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

  def pending!
    self.status = "pending"
  end
end
