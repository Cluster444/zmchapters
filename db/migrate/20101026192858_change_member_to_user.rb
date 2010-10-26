class ChangeMemberToUser < ActiveRecord::Migration
  def self.up
    rename_table :members, :users
    rename_column :chapters, :members_count, :users_count
  end

  def self.down
    rename_table :users, :members
    rename_column :chapters, :users_count, :members_count
  end
end
