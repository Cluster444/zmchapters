class Chapter < ActiveRecord::Base
  attr_accessible :region, :description

  has_and_belongs_to_many :country
  has_many :members

  default_scope order('region')

  def members_count
    unless member_count.nil?
      member_count
    else
      member_count = members.count
      self.update_attributes :member_count => member_count
      member_count
    end
  end
end
