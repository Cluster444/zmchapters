class AddUsersCountToCountry < ActiveRecord::Migration
  def self.up
    add_column :countries, :users_count, :integer
  end

  def self.down
    remove_column :countries, :users_count
  end
end
