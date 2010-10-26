Factory.define :chapter do |f|
  f.region 'test'
  f.description 'test'
  f.language 'test'
end

Factory.define :user do |f|
  f.name 'test test'
  f.alias 'test'
  f.email 'test@test.com'
  f.password 'foobarbaz'
  f.password_confirmation 'foobarbaz'
end

Factory.define :country do |f|
  f.name 'Canada'
  f.currency_code 'CAD'
  f.fips_code 'CA'
  f.country_code 'CA'
  f.iso_numeric '22'
  f.capital 'Ottawa'
  f.area_in_sq_km '200'
  f.languages 'en fr'
  f.iso_alpha3 'CA'
  f.continent 'NA'
  f.geoname_id '1111111'
  f.population '800'
end
