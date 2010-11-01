class ChangeAliasToUsernameForUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :alias, :username
  end

  def self.down
    rename_column :users, :username, :alias
  end
end
