class CreateTestIndices < ActiveRecord::Migration
  def self.up
    create_table :test_indices do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :test_indices
  end
end
