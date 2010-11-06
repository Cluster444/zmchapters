class AddStatusAndCategoryToChapters < ActiveRecord::Migration
  def self.up
    add_column :chapters, :category, :string
    add_column :chapters, :status, :string
  end

  def self.down
    remove_column :chapters, :status
    remove_column :chapters, :category
  end
end
