class Coordinator < ActiveRecord::Base
  attr_accessible :user, :chapter

  belongs_to :user
  belongs_to :chapter

  before_validation :set_chapter_of_user, :if => 'chapter.nil?'

  validates :user,    :presence => true
  validates :chapter, :presence => true

  def set_chapter_of_user
    self.chapter = self.user.chapter unless self.user.nil?
  end
end
