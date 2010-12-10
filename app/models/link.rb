class Link < ActiveRecord::Base
  attr_accessible :url, :title, :linkable
  belongs_to :linkable, :polymorphic => true

  validates :url, :presence => true, :length => {:maximum => 255}
  validates :title, :presence => true, :length => {:maximum => 255}
  validates :linkable, :presence => true
end
