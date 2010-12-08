class GeographicLocation < ActiveRecord::Base
  acts_as_nested_set

  has_many :chapters
  has_many :users

  validates :name, :presence => true, :length => {:maximum => 255}
  validates :lat,  :presence => true
  validates :lng,  :presence => true
  validates :zoom, :presence => true

  scope :continents,     roots
  scope :countries,      where(:depth => 1)
  scope :territories,    where(:depth => 2)
  scope :subterritories, where(:depth => 3)
  
  def self.map_hash
    {
      :lat => 0,
      :lng => 0,
      :zoom => 2,
      :markers => markers,
      :events => false
    }
  end

  def self.markers
    select(:lat, :lng).where("lat != 'nil' AND lng != 'nil' AND depth > 2")
  end

  def map_hash
    {
      :lat => (lat || 0),
      :lng => (lng || 0),
      :zoom => (zoom || 2),
      :markers => GeographicLocation.markers,
      :events => false
    }
  end

  def need_coordinates?
    lat.nil? || lng.nil? || zoom.nil?
  end

  def is_continent?
    root?
  end

  def is_country?
    depth == 1
  end

  def is_territory?
    depth == 2
  end

  def is_subterritory?
    depth == 3
  end

  def self_and_ancestors_name
    if is_territory?
      "#{name}, #{parent.name}, #{parent.parent.name}"
    elsif is_country?
      "#{name}, #{parent.name}"
    else
      "#{name}"
    end
  end

  def self_and_parent_name
    if is_territory? or is_country?
      "#{name}, #{parent.name}"
    else
      "#{name}"
    end
  end
end
