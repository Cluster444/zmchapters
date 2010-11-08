class AddNameToGeographicLocation < ActiveRecord::Migration
  def self.up
    add_column :geographic_locations, :name, :string
  end

  def self.down
    remove_column :geographic_locations, :name
  end
end
