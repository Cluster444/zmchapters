Feature: Find a chapter
  In order to become more involved in the movement
  As a volunteer
  I want to be able to find a chapter in my area
  
  Background:
    Given I am a new, authenticated member
    And I have a city chapter named "Calgary" in "Alberta, Canada, North America"

  Scenario: Find a chapter by browsing
    Given I am on the home page
    When I follow "Chapters"
    And I follow "Calgary"
    Then I should see "Join this chapter"

  Scenario: Find a chapter by searching
    Given I am on the chapters page
    Then I should see "Search"
    When I fill in "Calgary" for "chapter_search"
    And I press "Search"
    Then I shuold "Calgary"
    And I should see "Join this chapter"

  Scenario: Find a chapter by geography
    Given I am on the geo page
    When I follow "North America"
    And I follow "Canada"
    And I follow "Alberta"
    Then I should see "Calgary"
    When I follow "Calgary"
    Then I should see "Calgary"
    And I should see "Join this chapter"
