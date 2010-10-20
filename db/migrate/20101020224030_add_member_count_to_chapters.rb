class AddMemberCountToChapters < ActiveRecord::Migration
  def self.up
    add_column :chapters, :member_count, :integer
  end

  def self.down
    remove_column :chapters, :member_count
  end
end
