class User < ActiveRecord::Base
  attr_accessible :name, :username, :email, :password
  devise :database_authenticatable, :rememberable, :recoverable, :trackable, :validatable

  belongs_to :geographic_location
  belongs_to :chapter

  validates :name, :presence => true, :length => {:maximum => 50}
  validates :username, :presence => true, :uniqueness => true, :length => {:maximum => 30}
  validates :email, :presence => true, :uniqueness => true

  before_validation :associate_with_chapter_geographic_location

  def associate_with_chapter_geographic_location
    self.geographic_location = chapter.geographic_location unless chapter.nil?
  end

  def is_admin!
    update_attribute :admin, true
  end

  def is_not_admin!
    update_attribute :admin, false
  end

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end
