class Chapter < ActiveRecord::Base
  STATES = %w(pending active inactive)
  CATEGORIES = %w(country state province territory city county university)

  belongs_to :geographic_location
  has_many :users
  has_many :coordinators
  
  before_create :pending!

  validates :name, :presence => true, 
                   :length => {:maximum => 50}

  validates :category, :presence => true, 
                       :inclusion => {:in => CATEGORIES}

  validates :status, :presence => true, 
                     :inclusion => {:in => STATES}, 
                     :unless => :new_record?
  
  validates :geographic_location, :presence => true
  
  def pending!
    self.status = "pending"
  end

  def self.search_name(search)
    result = where('name = ?', search)
    if result.any?
      result.first
    else
      where('name LIKE ?', "%#{search}%")
    end
  end
end
