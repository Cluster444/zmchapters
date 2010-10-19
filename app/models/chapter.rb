class Chapter < ActiveRecord::Base
  attr_accessible :region, :description, :parent_id
end
