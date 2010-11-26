Feature: Find a chapter
  In order to become more involved in the movement
  As a volunteer
  I want to be able to find a chapter in my area
  
  Background:
    Given a user exists with name: "Test User"
    And is logged in
    And a location exists for "Alberta, Canada, North America"
    And a city chapter exists for "Calgary" in "Alberta"

  Scenario: Find a chapter by browsing
    Given I am on the home page
    When I follow "Chapters"
    And I follow "Calgary"
    And I press "Join this chapter"
    Then I should be on Test User's profile page
    And I should see "Calgary"
  
  Scenario: Find a chapter by searching with exact match
    Given I am on the chapters page
    When I fill in "Calgary" for "search"
    And I press "search-button"
    And I follow "Calgary"
    And I press "Join this chapter"
    Then I should be on Test User's profile page
    And I should see "Calgary"

  Scenario: Find a chapter by geography
    Given I am on the geo page
    When I go to the Alberta geo page
    And I follow "Calgary"
    And I press "Join this chapter"
    Then I should be on Test Uerr's profile page
    And I should see "Calgary"
