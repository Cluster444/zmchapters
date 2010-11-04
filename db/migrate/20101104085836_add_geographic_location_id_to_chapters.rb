class AddGeographicLocationIdToChapters < ActiveRecord::Migration
  def self.up
    add_column :chapters, :geographic_location_id, :integer
  end

  def self.down
    remove_column :chapters, :geographic_location_id
  end
end
