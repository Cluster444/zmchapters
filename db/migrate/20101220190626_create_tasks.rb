class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :status, :default => 'new'
      t.string :priority, :default => 'normal'
      t.string :category
      t.string :subject
      t.text :description
      t.datetime :starts_at
      t.datetime :due_at
      t.integer :percent_complete
      t.references :taskable, :polymorphic => true

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
