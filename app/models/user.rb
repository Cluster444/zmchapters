class User < ActiveRecord::Base
  belongs_to :geographic_location
  belongs_to :chapter

  before_validation :associate_with_chapter_geographic_location

  def associate_with_chapter_geographic_location
    self.geographic_location = chapter.geographic_location unless chapter.nil?
  end
end
