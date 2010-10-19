class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :name
      t.string :alias
      t.string :email
      t.string :password_hash
      t.string :salt
      t.string :status
      t.integer :chapter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
