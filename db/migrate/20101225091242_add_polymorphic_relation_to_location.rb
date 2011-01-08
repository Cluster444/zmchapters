class AddPolymorphicRelationToLocation < ActiveRecord::Migration
  def self.up
    change_table :locations do |t|
      t.references :locatable, :polymorphic => true
    end
  end

  def self.down
    remove_column :locations, :locatable_type
    remove_column :locations, :locatable_id
  end
end
