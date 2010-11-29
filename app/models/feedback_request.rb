class FeedbackRequest < ActiveRecord::Base
  CATEGORIES = %w(bug feature)
  STATES = %w(new acknowledged resolved closed rejected)

  validates :email,    :presence => true, :length => {:maximum => 255}
  validates :subject,  :presence => true, :length => {:maximum => 255}
  validates :message,  :presence => true, :length => {:maximum => 4096}
  validates :category, :presence => true, :inclusion => {:in => CATEGORIES}

  scope :new_requests, where(:status => 'new')
  scope :acknowledged, where(:status => 'acknowledged')
  scope :resolved,     where(:status => 'resolved')
  scope :closed,       where(:status => 'closed')
  scope :rejected,     where(:status => 'rejected')

  before_create lambda { self.status = "new" }

  def acknowledge!
    update_attribute :status, "acknowledged"
  end
  
  def resolve!
    update_attribute :status, "resolved"
  end

  def close!
    update_attribute :status, "closed"
  end

  def reject!
    update_attribute :status, "rejected"
  end

  def new?
    self.status == "new"
  end

  def acknowledged?
    self.status == "acknowledged"
  end

  def resolved?
    self.status == "resolved"
  end

  def closed?
    self.status == "closed"
  end

  def rejected?
    self.status == "rejected"
  end
end
