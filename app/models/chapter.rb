class Chapter < ActiveRecord::Base
  attr_accessible :region, :description

  has_and_belongs_to_many :country
  has_many :members

  default_scope order('region')
end
