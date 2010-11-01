class ChangeGeographicTerritoryIdToGeographicLocationIdOnChapters < ActiveRecord::Migration
  def self.up
    rename_column :chapters, :geographic_territory_id, :geographic_location_id
  end

  def self.down
    rename_column :chapters, :geographic_location_id, :geographic_territory_id
  end
end
