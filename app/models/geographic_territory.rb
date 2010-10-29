class GeographicTerritory < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :chapters

  scope :continents, where(:depth => 1)
  scope :countries, where(:depth => 2)
  scope :territories, where(:depth => 3)

  def continent?
    depth == 1
  end

  def country?
    depth == 2
  end

  def territory?
    depth == 3
  end

  def has_chapter?
    !Chapter.find_by_geographic_territory_id(id).nil?
  end

  def self.countries_with_chapters
    countries.joins(:chapters)
  end
end
