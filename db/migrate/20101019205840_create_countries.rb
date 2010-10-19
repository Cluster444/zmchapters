class CreateCountries < ActiveRecord::Migration
  def self.up
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
      t.string :languages
      t.string :area_in_sq_km
      t.string :population
      t.timestamps
    end
  end

  def self.down
    drop_table :countries
  end
end
