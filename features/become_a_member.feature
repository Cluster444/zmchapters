Feature: Become a member
  In order to join the zeitgeist movement
  As a volunteer
  I want to be able to register

  Scenario: Create a user profile
    Given I am not logged in
    And I am on the home page
    Then I should see "Sign Up"
    When I follow "Sign Up"
    Then I should see "Sign Up"
    When I fill in the following:
      | Name                       | Test User  |
      | Username                   | Tester     |
      | Email                      | t@test.com |
      | Password                   | foobarbaz  |
      | user_password_confirmation | foobarbaz  |
    And I press "Sign Up"
    Then I should see "Test User"
    And I should see "Tester"
    And I should see "Find a chapter in your area"
    When I follow "Find a chapter in your area"
    Then I should be on the chapters page
