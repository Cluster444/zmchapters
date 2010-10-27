class AddCountryIdToChapter < ActiveRecord::Migration
  def self.up
    drop_table :chapters_countries
    add_column :chapters, :country_id, :integer
  end

  def self.down
    create_table :chapters_countries, :id => false do |t|
      t.integer :country_id
      t.integer :chapter_id
    end

    remove_column :chapters, :country_id
  end
end
