class Coordinator < ActiveRecord::Base
  belongs_to :user
  belongs_to :chapter

  validates :user, :presence => true
  validates :chapter, :presence => true
end
