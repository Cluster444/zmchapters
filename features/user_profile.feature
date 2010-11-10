Feature: User Profile
  In order to maintain my information
  As a member of the site
  I want to be able to create and maintain a profile
  
  Background: Geography
    Given I have geography

  Scenario: View my profile
    Given I am a new, authenticated user
    And I am on the home page
    When I follow "Profile"
    Then I should see "Test User"
    And I should see "Tester"

  Scenario: Create profile
    Given I am on the home page
    When I follow "Sign Up"
    And I fill in the following:
      | Name                       | Test User  |
      | Username                   | Tester     |
      | Email                      | t@test.com |
      | Password                   | foobarbaz  |
      | user_password_confirmation | foobarbaz  |
    And I press "Sign Up"
    Then I should see "Profile created successfully"
    And I should see "Test User"
    And I should see "Tester"

  Scenario: Edit profile
    Given I am a new, authenticated user
    And I am on the home page
    When I follow "Profile"
    And I follow "Edit my profile"
    And I fill in the following:
      | Name             | Edit User  |
      | Username         | Editor     |
      | Email            | e@test.com |
      | Current Password | foobarbaz  |
    And I press "Save Profile"
    Then I should see "Profile updated successfully"
    And I should see "Edit User"
    And I should see "Editor"

  Scenario: Change Password
