Given /^I have chapters named (.+)$/ do |names|
  names.split(', ').each do |name|
    Factory(:chapter, :name => name)
  end
end

Given /^I have no chapters$/ do
  Chapter.delete_all
end

Given /^I have geography$/ do
  root = Factory(:geo, :name => "Root")
  continent = Factory(:geo, :name => "Continent")
  country = Factory(:geo, :name => "Country")
  territory = Factory(:geo, :name => "Territory")
  continent.move_to_child_of root
  country.move_to_child_of continent
  territory.move_to_child_of country
end

Then /^I should have (\d+) chapters?$/ do |count|
  Chapter.count.should == count.to_i
end
