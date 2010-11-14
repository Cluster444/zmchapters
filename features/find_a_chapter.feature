Feature: Find a chapter
  In order to become more involved in the movement
  As a volunteer
  I want to be able to find a chapter in my area
  
  Background:
    Given a user exists
    And is logged in
    And a location exists for "Alberta, Canada, North America"
    And a city chapter exists for "Calgary" in "Alberta"

  Scenario: Find a chapter by browsing
    Given I am on the home page
    When I follow "Chapters"
    And I follow "Calgary"
    And I press "Join this chapter"
    Then I should see "My Profile"
    And I should see "Calgary"
  
  Scenario: Find a chapter by searching with exact match
    Given I am on the chapters page
    When I fill in "Calgary" for "search_name"
    And I press "Search"
    And I press "Join this chapter"
    Then I should see "My Profile"
    And I should see "Calgary"

  Scenario: Find a chapter by geography
    Given I am on the geo page
    When I follow "North America"
    And I follow "Canada"
    And I follow "Alberta"
    And I follow "Calgary"
    And I press "Join this chapter"
    Then I should see "My Profile"
    And I should see "Calgary"
