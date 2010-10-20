class Country < ActiveRecord::Base
  attr_accessible :name, :currency_code, :fips_code, :country_code, :iso_numeric, :capital,
                  :area_in_sq_km, :languages, :iso_alpha3, :continent, :geoname_id, :population
  
  has_and_belongs_to_many :chapters

  default_scope order('name')

  def member_count
    count = 0
    self.chapters.each do |chapter|
      count += chapter.members.count
    end
    count
  end
end
