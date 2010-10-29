class ChangeCountryIdToGeographicTerritoryIdOnChapters < ActiveRecord::Migration
  def self.up
    rename_column :chapters, :country_id, :geographic_territory_id
  end

  def self.down
    rename_column :chapters, :geographic_territory_id, :country_id
  end
end
