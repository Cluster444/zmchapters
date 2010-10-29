class CreateGeographicTerritories < ActiveRecord::Migration
  def self.up
    create_table :geographic_territories do |t|
      t.string :name
      t.integer :geoname_id
      t.string :fcode
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth

      t.timestamps
    end
  end

  def self.down
    drop_table :geographic_territories
  end
end
