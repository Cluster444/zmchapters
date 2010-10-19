class RemoveParentIdFromChapters < ActiveRecord::Migration
  def self.up
    remove_column :chapters, :parent_id
  end

  def self.down
    add_column :chapters, :parent_id, :integer
  end
end
