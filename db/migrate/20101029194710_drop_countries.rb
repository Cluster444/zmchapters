class DropCountries < ActiveRecord::Migration
  def self.up
    drop_table :countries
  end

  def self.down
    create_table :countries do |t|
      t.string :geoname_id
      t.string :country_code
      t.string :fips_code
      t.string :currency_code
      t.string :iso_numeric
      t.string :iso_alpha3
      t.string :continent
      t.string :name
      t.string :capital
      t.string :languagaes
      t.string :area_in_sq_km
      t.string :population
      t.integer :users_count
      t.timestamps
    end
  end
end
