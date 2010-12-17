class User < ActiveRecord::Base
  extend Index
  index do |i|
    i.search :name, :username
    i.sort :name, :username
    i.default_sort :username, :asc
    i.paginate 20
  end

  attr_accessible :name, :username, :email, :password
  devise :database_authenticatable, :rememberable, :recoverable, :trackable, :validatable

  belongs_to :chapter
  has_many :coordinators

  validates :name,     :presence => true, :length => {:maximum => 50}
  validates :username, :presence => true, :uniqueness => true, :length => {:maximum => 30}

  def coordinator?
    coordinators.any?
  end

  def name_with_username
    "#{name} (#{username})"
  end

  def location
    unless self.chapter.nil?
      chapter.geographic_location
    else
      GeographicLocation.new(:name => "Unknown")
    end
  end

  def is_admin!
    update_attribute :admin, true
  end

  def is_not_admin!
    update_attribute :admin, false
  end
end
