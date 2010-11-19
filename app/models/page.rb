class Page < ActiveRecord::Base
  validates :uri, :presence => true, :length => {:maximum => 100}, :format => {:with => /^[a-zA-Z1-9_]+$/}
  validates :title, :presence => true, :length => {:maximum => 255}
  validates :content, :presence => true, :length => {:maximum => 8096}
end
