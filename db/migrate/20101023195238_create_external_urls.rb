class CreateExternalUrls < ActiveRecord::Migration
  def self.up
    create_table :external_urls do |t|
      t.string :url
      t.string :title
      t.string :type
      t.integer :sort_order, :default => 0
      t.integer :chapter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :external_urls
  end
end
