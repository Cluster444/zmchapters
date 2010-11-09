Given /^I have chapters named (.+)$/ do |names|
  names.split(', ').each do |name|
    Factory(:chapter, :name => name)
  end
end
