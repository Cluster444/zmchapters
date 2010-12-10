class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :title
      t.string :url
      t.references :linkable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
