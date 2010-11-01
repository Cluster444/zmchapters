class ChangeGeographicTerritoryToGeographicLocation < ActiveRecord::Migration
  def self.up
    rename_table :geographic_territories, :geographic_locations
  end

  def self.down
    rename_table :geographic_locations, :geographic_territories
  end
end
