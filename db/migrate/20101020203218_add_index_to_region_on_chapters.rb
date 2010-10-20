class AddIndexToRegionOnChapters < ActiveRecord::Migration
  def self.up
    add_index :chapters, :region
  end

  def self.down
    remove_index :chapters, :region
  end
end
