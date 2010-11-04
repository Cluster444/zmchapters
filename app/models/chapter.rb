class Chapter < ActiveRecord::Base
  belongs_to :geographic_location
  has_many :users
end
