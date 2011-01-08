class ChangeGeographicLocationToLocationOnChapter < ActiveRecord::Migration
  def self.up
    rename_column :chapters, :geographic_location_id, :location_id
  end

  def self.down
    rename_column :chapters, :location_id, :geographic_location_id
  end
end
