class AddNameToChapters < ActiveRecord::Migration
  def self.up
    add_column :chapters, :name, :string
  end

  def self.down
    remove_column :chapters, :name
  end
end
