Given(/^is logged in$/) do
  password = Factory.attributes_for(:user)[:password]
  email = User.last.email
  Given %{I am on the login page}
  And %{I fill in "#{email}" for "Email"}
  And %{I fill in "#{password}" for "Password"}
  And %{I press "Sign In"}
end

Given(/^is not logged in$/) do
  visit '/users/sign_out'
end

Given(/^I am not logged in$/) do
  visit '/users/sign_out'
end
