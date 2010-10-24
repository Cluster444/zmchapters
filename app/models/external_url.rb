class ExternalUrl < ActiveRecord::Base
  self.inheritance_column = :super_type
  attr_accessible :url, :type, :title, :sort_order

  belongs_to :chapter
end
