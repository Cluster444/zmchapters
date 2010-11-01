class AddGeographicLocationIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :geographic_location_id, :integer
  end

  def self.down
    remove_column :users, :geographic_location_id
  end
end
