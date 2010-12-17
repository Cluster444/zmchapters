class SiteOption < ActiveRecord::Base
  attr_accessible :key, :value

  self.inheritance_column = '_type'
  TYPES = ['string','reference','list','set','hash']

  validates :key,   :presence => true, :uniqueness => true, :length => {:maximum => 30}, :format => {:with => /^[a-z_]+$/}
  validates :type,  :presence => true, :inclusion => {:in => TYPES}
  validates :value, :presence => true, :length => {:maximum => 255}
  validates :mutable, :presence => true
end
