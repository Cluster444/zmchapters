Transform(/^(should|should not)$/) do |should_or_not|
  should_or_not.gsub(' ','_').to_sym
end

#Then(/^I (should|should not) see a create chapter form$/) do |should_or_not|
#  page.send should_or_not have_xpath("//form[@action='#{chapters_path}']")
#end

Then(/^I should see a create chapter form$/) do
  page.should have_xpath("//form[@action='#{chapters_path}']")
end

Then(/^I should not see a create chapter form$/) do
  page.should_not have_xpath("//form[@action='#{chapters_path}']")
end

Then(/^"([^"]+)" should be selected for "([^"]+)"$/) do |value, field|
  page.should have_xpath("//option[@selected = 'selected' and contains(string(), #{value})]")
end
