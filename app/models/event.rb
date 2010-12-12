class Event < ActiveRecord::Base
  attr_accessible :title, :description, :starts_at, :ends_at

  belongs_to :plannable, :polymorphic => true

  validates :title,       :presence => true, :length => {:maximum => 255}
  validates :description, :presence => true, :length => {:maximum => 500}
  validates :starts_at,   :presence => true
  validates :ends_at,     :presence => true

  validate :starts_at_is_in_the_future, :ends_at_is_after_start

  def starts_at_is_in_the_future
    errors.add(:starts_at, "can't be in the past") if starts_at.nil?  || starts_at < DateTime.now
  end

  def ends_at_is_after_start
    errors.add(:ends_at, "can't come before start") if ends_at.nil? || starts_at.nil? || ends_at < starts_at
  end
end
