class Page < ActiveRecord::Base
  attr_accessible :title, :content

  validates :uri, :presence => true, :length => {:maximum => 100}, :format => {:with => /^[a-zA-Z1-9_]+$/}
  validates :title, :presence => true, :length => {:maximum => 255}
  validates :content, :presence => true, :length => {:maximum => 8192}
end
