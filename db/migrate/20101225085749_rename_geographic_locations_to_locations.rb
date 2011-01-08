class RenameGeographicLocationsToLocations < ActiveRecord::Migration
  def self.up
    drop_table :geographic_locations
    create_table :locations do |t|
      t.string :name
      t.integer :geoname_id
      t.string :lat
      t.string :lng
      t.string :zoom
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
    create_table :geographic_locations do |t|
      t.string :name
      t.integer :geoname_id
      t.string :lat
      t.string :lng
      t.string :zoom
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth
      t.timestamps
    end
  end
end
