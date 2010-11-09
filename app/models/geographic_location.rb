class GeographicLocation < ActiveRecord::Base
  acts_as_nested_set

  has_many :chapters
  has_many :users

  validates :name, :presence => true, :length => {:maximum => 255}

  scope :continents, where(:depth => 1)
  scope :countries, where(:depth => 2)
  scope :territories, where(:depth => 3)
  
  def self.countries_with_chapters
    countries.reject {|country| not country.chapters.any?}
  end

  def is_continent?
    depth == 1
  end

  def is_country?
    depth == 2
  end

  def is_territory?
    depth == 3
  end
end
