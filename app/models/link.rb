class Link < ActiveRecord::Base
  extend Index
  index do |i|
    i.search :url
    i.sort :url, :title
    i.default_sort :url, :asc
    i.paginate 20
  end

  attr_accessible :url, :title, :linkable

  belongs_to :linkable, :polymorphic => true

  validates :url, :presence => true, :length => {:maximum => 255}
  validates :title, :presence => true, :length => {:maximum => 255}
  validates :linkable, :presence => true
end
