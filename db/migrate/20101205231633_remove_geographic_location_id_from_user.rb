class RemoveGeographicLocationIdFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :geographic_location_id
  end

  def self.down
    add_column :users, :geographic_location_id, :integer
  end
end
