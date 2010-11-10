Given /^I have an account with the name "([^"]*)" and the username "([^"]*)"$/ do |name, username|
  Given %{I have a user "#{username}" named "#{name}" with email "test@test.com" and password "foobarbaz"}
end

Given /^I have a user "([^"]*)" named "([^"]*)" with email "([^"]*)" and password "([^"]*)"$/ do |username,name,email,password|
  User.create! :name => name,
               :username => username,
               :email => email,
               :password => password,
               :password_confirmation => password
end

Given /^I am a new, authenticated user$/ do
  name = "Test User"
  username = "Tester"
  email = "test@test.com"
  password = "foobarbaz"

  Given %{I have a user "#{username}" named "#{name}" with email "#{email}" and password "#{password}"}
  And %{I go to login}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Sign In"}
end

Given /^I am not logged in $/ do
  visit '/users/sign_out'
end
