class AddGeonameIdToGeographicLocation < ActiveRecord::Migration
  def self.up
    add_column :geographic_locations, :geoname_id, :integer
  end

  def self.down
    remove_column :geographic_locations, :geoname_id
  end
end
