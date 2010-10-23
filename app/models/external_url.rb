class ExternalUrl < ActiveRecord::Base
  attr_accessible :url, :type, :title, :sort_order

  belongs_to :chapter
end
