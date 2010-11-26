class GeographicLocation < ActiveRecord::Base
  acts_as_nested_set

  has_many :chapters
  has_many :users

  validates :name, :presence => true, :length => {:maximum => 255}

  scope :continents, where(:depth => 0)
  scope :countries, where(:depth => 1)
  scope :territories, where(:depth => 2)
  
  def self.countries_with_chapters
    countries.reject {|country| not country.chapters.any?}
  end

  def children_with_chapters
    children.reject {|child| not child.chapters.any?}
  end

  def children_without_chapters
    children.reject {|child| child.chapters.any?}
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
