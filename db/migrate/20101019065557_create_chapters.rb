class CreateChapters < ActiveRecord::Migration
  def self.up
    create_table :chapters do |t|
      t.string :region
      t.text :description
      t.integer :parent_id
      t.text :language

      t.timestamps
    end
  end

  def self.down
    drop_table :chapters
  end
end
