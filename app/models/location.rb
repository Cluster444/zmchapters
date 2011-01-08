class Location < ActiveRecord::Base
  acts_as_nested_set

  attr_accessible :name, :lat, :lng, :zoom

  belongs_to :locatable, :polymorphic => true

  validates :name, :presence => true, :length => {:maximum => 255}
  validates :lat,  :presence => true
  validates :lng,  :presence => true
  validates :zoom, :presence => true

  scope :continents,     roots
  scope :nations,        where(:depth => 1)
  scope :regions,        where(:depth => 2)
  scope :locals,         where(:depth => 3)
  
  def self.map_hash
    {
      :lat => 0,
      :lng => 0,
      :zoom => 2,
      :markers => markers,
      :events => false
    }
  end
  
  #TODO Make this take an argument to allow more specific selections
  def self.markers
    select(:lat, :lng).where("lat != 'nil' AND lng != 'nil' AND depth > 2")
  end

  def map_hash
    {
      :lat => (lat || 0),
      :lng => (lng || 0),
      :zoom => (zoom || 2),
      :markers => Location.markers,
      :events => false
    }
  end

  def need_coordinates?
    lat.nil? || lng.nil? || zoom.nil?
  end

  def is_continental?
    root?
  end

  def is_national?
    depth == 1
  end

  def is_regional?
    depth == 2
  end

  def is_local?
    depth == 3
  end

  def self_and_ancestors_name
    if is_continental?
      "#{name}"
    else
      "#{name}, #{parent.self_and_ancestors_name}"
    end
  end

  def self_and_parent_name
    if is_continental?
      "#{name}"
    else
      "#{name}, #{parent.name}"
    end
  end
end
