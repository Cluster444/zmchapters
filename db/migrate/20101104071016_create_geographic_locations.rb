class CreateGeographicLocations < ActiveRecord::Migration
  def self.up
    create_table :geographic_locations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :geographic_locations
  end
end
