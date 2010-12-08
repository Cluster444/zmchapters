class Coordinator < ActiveRecord::Base
  attr_accessible :user, :chapter

  belongs_to :user
  belongs_to :chapter

  validates :user, :presence => true
  validates :chapter, :presence => true
end
