class AddChapterToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :chapter_id, :integer
  end

  def self.down
    remove_column :users, :chapter_id
  end
end
