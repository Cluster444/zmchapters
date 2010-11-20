class CreateSiteOptions < ActiveRecord::Migration
  def self.up
    create_table :site_options do |t|
      t.string :key
      t.string :type
      t.string :value
      t.boolean :mutable

      t.timestamps
    end
  end

  def self.down
    drop_table :site_options
  end
end
