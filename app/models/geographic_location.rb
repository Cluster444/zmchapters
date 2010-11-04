class GeographicLocation < ActiveRecord::Base
  acts_as_nested_set
  has_many :chapters
  has_many :users
end
