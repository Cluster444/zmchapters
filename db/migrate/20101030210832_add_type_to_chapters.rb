class AddTypeToChapters < ActiveRecord::Migration
  def self.up
    add_column :chapters, :type, :string
  end

  def self.down
    remove_column :chapters, :type
  end
end
