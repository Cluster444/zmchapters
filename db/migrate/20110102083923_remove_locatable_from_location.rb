class RemoveLocatableFromLocation < ActiveRecord::Migration
  def self.up
    remove_column :locations, :locateable_type
    remove_column :locations, :locateable_id
  end

  def self.down
    change_table :locations do |t|
      t.references :locateable, :polymorphic => true
    end
  end
end
