class Coordinator < ActiveRecord::Base
  belongs_to :user
  belongs_to :chapter
end
