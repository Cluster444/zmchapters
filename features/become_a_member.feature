Feature: Become a member
  In order to join the zeitgeist movement
  As a volunteer
  I want to be able to register

  Background:
    Given I am not logged in
    And I am on the home page
    And a location exists for "Alberta, Canada, North America"
    When I follow "Sign Up"
    When I fill in the following:
      | Name                       | Test User  |
      | Username                   | Tester     |
      | Email                      | t@test.com |
      | Password                   | foobarbaz  |
      | user_password_confirmation | foobarbaz  |
    
  Scenario: Create a user profile
    When I press "Sign Up"
    Then I should see "Test User"
    And I should see "Tester"
    And I should see "Join a chapter"

  @wip @capybara
  Scenario: Create a user profile(with js)
    When I select "Canada" from "geo_country_id"
    And I select "Alberta" from "geo_id"
    And I press "Sign Up"
    Then I should see "Test User"
    And I should see "Tester"
    And I should see "Find a chapter in your area"
