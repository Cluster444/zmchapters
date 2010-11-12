Given(/^a (\w+) chapter exists for "([^"]+)" in "([^"]+)"$/) do |category, chapter, location|
  Factory(:chapter, :name => chapter, 
                    :category => category,
                    :geographic_location => GeographicLocation.find_by_name(location))
end
