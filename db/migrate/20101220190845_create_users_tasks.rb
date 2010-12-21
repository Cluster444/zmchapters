class CreateUsersTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks_users, :id => false do |t|
      t.integer :task_id
      t.integer :user_id
      t.boolean :active,      :default => true
      t.boolean :coordinator, :default => false
    end
  end

  def self.down
    drop_table :tasks_users
  end
end
