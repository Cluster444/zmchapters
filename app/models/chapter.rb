class Chapter < ActiveRecord::Base
  STATES = %w(pending active inactive)
  CATEGORIES = %w(country state province territory city county university)

  belongs_to :geographic_location
  has_many :users
  has_many :coordinators
  
  before_create :pending!

  validates :name,     :presence => true, :length => {:maximum => 100}
  validates :category, :presence => true, :length => {:maximum => 255}
  validates :status,   :presence => true, :inclusion => {:in => STATES}, :unless => :new_record?
  validates :geographic_location, :presence => true
  
  def pending!
    self.status = "pending"
  end
  
  def self.index(opts={})
    if opts.any?
      where("name LIKE ?", "%#{opts[:search]}%")
          .order("#{opts[:sort]} #{opts[:direction]}")
          .paginate(:per_page => opts[:per_page], :page => opts[:page])
    else
      order("name ASC").paginate(:per_page => 20, :page => 1)
    end
  end
end
