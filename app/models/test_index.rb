class TestIndex < ActiveRecord::Base
  extend Index
  
  #index do
  #  search :name
  #  sort :name, :created_at, :updated_at, :default => {:column => :name, :order => :asc}
  #  paginate :per_page => 20
  #end   
end
