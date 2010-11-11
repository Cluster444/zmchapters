Given /^I have a location "(?:(?:([a-zA-Z ]+), )?(?:([a-zA-Z ]+), ))?([a-zA-Z ]+)"$ do |territory, country, continent|
  root = GeographicLocation.root || Factory(:geo, :name => "Earth")
  if territory
    Given %{I have a location "#{country}, #{continent}"}
    geo_country = GeographicLocation.find_by_name(country)
    Factory(:geo, territory).move_to_child_of geo_country
  elsif country
    Given %{I have a location "#{continent}"}
    geo_continent = GeographicLocation.find_by_name(continent)
    Factory(:geo, :name => country).move_to_child_of geo_continent
  else
    Factory(:geo, :name => continent).move_to_child_of root
  end
end

Given /^I have basic geography$/ do
  Given %{I have a location "Territory, Country, Continent"}
end
