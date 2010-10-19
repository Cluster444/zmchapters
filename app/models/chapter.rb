class Chapter < ActiveRecord::Base
  attr_accessible :title, :description, :parent_id
end
