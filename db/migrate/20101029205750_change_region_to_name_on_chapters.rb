class ChangeRegionToNameOnChapters < ActiveRecord::Migration
  def self.up
    rename_column :chapters, :region, :name
  end

  def self.down
    rename_column :chapters, :name, :region
  end
end
