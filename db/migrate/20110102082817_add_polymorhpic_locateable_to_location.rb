class AddPolymorhpicLocateableToLocation < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.references :locateable, :polymorphic => true
    end
  end

  def self.down
    remove_column :location, :locateable_type
    remove_column :location, :locateable_id
  end
end
