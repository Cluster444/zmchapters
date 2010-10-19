class CreateChaptersCountries < ActiveRecord::Migration
  def self.up
    create_table :chapters_countries, :id => false do |t|
      t.references :chapter
      t.references :country
    end
  end

  def self.down
    drop_table :chapters_countries
  end
end
