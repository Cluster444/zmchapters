Feature: Become a member
  In order to join the zeitgeist movement
  As a volunteer
  I want to be able to register and join a local
  chapter in my area.

  @wip
  Scenario: Create a user profile
    Given I am not logged in
    And I am on the home page
    Then I should see "Sign Up"
    When I follow "Sign Up"
    Then I should see "==some greeting text=="
    When I fill in the following:
      | some | info |
    And I press "Sign Up"
    Then I should see "==some name=="
    And I should see "==some username=="
    And I should see "Find a chapter in your area"
    When I follow "Find a chapter in your area"
    Then I should see "Chapters Index"

  Scenario: Find a chapter
    Given I am a new, authenticated member
    And I am on the home page
    When I follow "Chapters"
    Then I should see "Search"
    When I fill in 

  Scenario: Join a chapter
