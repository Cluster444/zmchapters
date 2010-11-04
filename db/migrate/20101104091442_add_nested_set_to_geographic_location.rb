class AddNestedSetToGeographicLocation < ActiveRecord::Migration
  def self.up
    add_column :geographic_locations, :parent_id, :integer
    add_column :geographic_locations, :lft, :integer
    add_column :geographic_locations, :rgt, :integer
    add_column :geographic_locations, :depth, :integer
  end

  def self.down
    remove_column :geographic_locations, :depth
    remove_column :geographic_locations, :rgt
    remove_column :geographic_locations, :lft
    remove_column :geographic_locations, :parent_id
  end
end
