class Chapter < ActiveRecord::Base
  #TODO Add a subchapter scope

  extend Index
  index do |i|
    i.search :name
    i.sort :name
    i.default_sort :name, :asc
    i.paginate 20
  end

  STATES = %w(pending active inactive)

  attr_accessible :name

  has_one :location, :as => :locatable
  has_many :members, :class_name => 'User'
  has_many :coordinators
  has_many :links, :as => :linkable
  has_many :events, :as => :plannable
  
  before_create proc { self.status = 'pending' }

  validates :name, :length => {:maximum => 255}
  
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
