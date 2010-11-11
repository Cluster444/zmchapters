Given /^I have chapters named (.+)$/ do |names|
  names.split(', ').each do |name|
    Factory(:chapter, :name => name)
  end
end

Given /^I have no chapters$/ do
  Chapter.delete_all
end

# Given I have a <type> chapter named "<chapter>" in "<geo>"
Given /^I have a ([a-zA-Z]+) chapter named "([^"]+)" in "([^"]+)"$/ do |category, name, geo_name|
  Given %{I have a location "#{geo_name}"}
  territory_name = geo_name.split(", ").first
  geo = GeographicLocation.find_by_name(territory_name)
  Factory(:chapter, :name => name, :category => category, :geographic_location => geo
end

Then /^I should have (\d+) chapters?$/ do |count|
  Chapter.count.should == count.to_i
end
