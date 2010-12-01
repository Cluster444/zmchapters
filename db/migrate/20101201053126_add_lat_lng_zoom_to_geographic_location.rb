class AddLatLngZoomToGeographicLocation < ActiveRecord::Migration
  def self.up
    add_column :geographic_locations, :lat, :string
    add_column :geographic_locations, :lng, :string
    add_column :geographic_locations, :zoom, :string
  end

  def self.down
    remove_column :geographic_locations, :zoom
    remove_column :geographic_locations, :lng
    remove_column :geographic_locations, :lat
  end
end
