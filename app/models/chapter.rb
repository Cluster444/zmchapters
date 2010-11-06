class Chapter < ActiveRecord::Base
  STATUS = %w(pending active inactive)
  CATEGORY = %w(country, state, province, territory, city, county, university)

  belongs_to :geographic_location
  has_many :users
  has_many :coordinators
  
  before_create :pending!

  validates :name, :presence => true, 
                   :length => {:maximum => 50}

  validates :category, :presence => true, 
                       :inclusion => {:in => CATEGORY}

  validates :status, :presence => true, 
                     :inclusion => {:in => STATUS}, 
                     :unless => :new_record?
  
  def pending!
    self.status = "pending"
  end
end
