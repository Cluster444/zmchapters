class ChangeMemberCountToMembersCountForChapters < ActiveRecord::Migration
  def self.up
    remove_column :chapters, :member_count
    add_column :chapters, :members_count, :integer, :default => 0

    Chapter.reset_column_information
    Chapter.all.each do |c|
      Chapter.update_counters c.id, :members_count => c.members.length
    end
  end

  def self.down
    remove_column :chapters, :members_count
    add_column :chapters, :member_count, :integer
  end
end
