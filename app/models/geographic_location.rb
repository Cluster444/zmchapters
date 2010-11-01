class GeographicLocation < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :chapters

  scope :continents, where(:depth => 1)
  scope :countries, where(:depth => 2)
  scope :territories, where(:depth => 3)

  def is_continent?
    depth == 1
  end

  def is_country?
    depth == 2
  end

  def is_territory?
    depth == 3
  end

  def has_chapter?
    !Chapter.find_by_geographi_location_id(id).nil?
  end
  
  def children_with_chapters
    children.reject {|child| !child.has_chapter?}
  end

  def children_without_chapters
    children.reject {|child| child.has_chapter?}
  end

  def self.find_countries_with_chapters
    countries.reject {|country| !country.has_chapter?}
  end
end
