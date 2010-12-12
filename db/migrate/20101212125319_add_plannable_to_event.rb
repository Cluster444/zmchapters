class AddPlannableToEvent < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.references :plannable, :polymorphic => true
    end
  end

  def self.down
    remove_column :events, :plannable
  end
end
