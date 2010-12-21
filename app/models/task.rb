class Task < ActiveRecord::Base
  belongs_to :taskable, :polymorphic => true
  has_and_belongs_to_many :users

  def self.valid_states
    %w(new in_progress resolved closed rejected)
  end

  def self.valid_priorities
    %w(low normal high urgent)
  end

  validates :status,           :presence => true, :inclusion => {:in => valid_states}
  validates :priority,         :presence => true, :inclusion => {:in => valid_priorities}
  validates :category,         :presence => true, :length => {:maximum => 255 }
  validates :subject,          :presence => true, :length => {:maximum => 255 }
  validates :description,      :presence => true, :length => {:maximum => 4096}
  validates :starts_at,        :presence => true
  validates :percent_complete, :presence => true, :inclusion => {:in => 0..100}
  validates :taskable,         :presence => true
  
  def self.find_new
    find_all_by_status :new
  end

  def self.find_in_progress
    find_all_by_status :in_progress
  end

  def self.find_resolved
    find_all_by_status :resolved
  end

  def self.find_closed
    find_all_by_status :closed
  end

  def self.find_rejected
    find_all_by_status :rejected
  end
end
