class AddUserAndChapterToCoordinators < ActiveRecord::Migration
  def self.up
    add_column :coordinators, :user_id, :integer
    add_column :coordinators, :chapter_id, :integer
  end

  def self.down
    remove_column :coordinators, :chapter_id
    remove_column :coordinators, :user_id
  end
end
