# Given a location exists for "Alberta, Canada, North America"
Given(/^a location exists for "(?:(?:([a-zA-Z ]+), )?(?:([a-zA-Z ]+), ))?([a-zA-Z ]+)"$/) do |territory, country, continent|
  if territory
    Given %{a location exists for "#{country}, #{continent}"}
    And %{a location exists with name: "#{territory}"}
    And %{"#{territory}" is a location within "#{country}"}
  elsif country
    Given %{a location exists for "#{continent}"}
    And %{a location exists with name: "#{country}"}
    And %{"#{country}" is a location within "#{continent}"}
  else
    Given %{a location exists with name: "#{continent}"}
  end
end

Given(/^a location exists with (.+)$/) do |fields|
  Given %{a geographic location exists with #{fields}}
end

Given(/^"([^"]+)" is a location within "([^"]+)"$/) do |child, parent|
  GeographicLocation.find_by_name(child).move_to_child_of(GeographicLocation.find_by_name(parent));
end

Given(/^basic geography exists$/) do
  Given %{a location exists for "Territory, Country, Continent"}
end
