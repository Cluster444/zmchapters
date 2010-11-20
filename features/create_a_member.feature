Feature: Create a new member
  In order to register a new user
  As an admin
  I need to be able to create new users
  
  Scenario: Admin control panel button
    Given an admin exists
    And is logged in
    And I am on the home page
    When I follow "Create Member"
    Then I should be on the new user page

  Scenario: Admin creates a user
    Given an admin exists
    And is logged in
    When I go to the new user page
    And I fill in the following:
      | Name                       | Test User |
      | Username                   | testuser |
      | Email                      | testuser@test.com |
      | Password                   | testuser |
      | user_password_confirmation | testuser |
    And I press "Create"
    Then I should see "created successfully"
    And I should see "Test User"
    And I should see "testuser"
  
  Scenario: Logged in user tries to create a user
    Given a user exists
    And is logged in
    When I go to the new user page
    Then I should be on the home page
    And I should see "not authorized"

  Scenario: Guest user tries to create a user with registration open
    Given a site_option exists with key: "site_registration", value: "open"
    When I go to the new user page
    And I fill in the following:
      | Name                       | Test User         |
      | Username                   | testuser          |
      | Email                      | testuser@test.com |
      | Password                   | testuser          |
      | user_password_confirmation | testuser          |
    And I press "Sign Up"
    Then I should see "created successfully"
    And I should see "Test User"
  
  @wip
  Scenario: Guest user tries to create a user with registration approval required
    When I go to the new user page
    And I fill in the following:
      | Name                       | Test User         |
      | Username                   | testuser          |
      | Email                      | testuser@test.com |
      | Password                   | testuser          |
      | user_password_confirmation | testuser          |
    And I press "Sign Up"
    Then I should be on the home page
    And I should see "created successfully"
    And I should see "awaiting approval"
  
  Scenario: Guest user tries to create a user with registration closed
    Given a site_option exists with key: "site_registration", value: "closed"
    When I go to the new user page
    Then I should be on the login page
    And I should see "not authorized"
