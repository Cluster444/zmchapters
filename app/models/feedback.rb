class Feedback < ActiveRecord::Base
  extend Index

  index do |i|
    i.search :subject, :message
    i.sort :email, :category, :created_at, :updated_at
    i.default_sort :created_at, :asc
    i.paginate 20
  end

  CATEGORIES = %w(bug feature)

  attr_accessible :email, :subject, :message, :category

  belongs_to :user

  validates :email,    :presence => true, :length => {:maximum => 255}, :if => "user.nil?"
  validates :subject,  :presence => true, :length => {:maximum => 255}
  validates :message,  :presence => true, :length => {:maximum => 4096}
  validates :category, :presence => true, :inclusion => {:in => CATEGORIES}
end
