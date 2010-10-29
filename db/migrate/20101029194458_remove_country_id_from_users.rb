class RemoveCountryIdFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :country_id
  end

  def self.down
    add_column :users, :country_id, :integer
  end
end
