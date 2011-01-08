class RemoveLocationIdFromChapters < ActiveRecord::Migration
  def self.up
    remove_column :chapters, :location_id
  end

  def self.down
    add_column :chapters, :location_id, :integer
  end
end
