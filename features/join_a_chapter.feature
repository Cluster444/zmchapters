Feature: Join a chapter
  In order to get involved with the movement
  As a volunteer
  I need to be able to join a chapter

  Background:
    Given a user exists
    And is logged in
    And a location exists for "Alberta, Canada, North America"
    And a city chapter exists for "Calgary" in "Alberta"

  Scenario: Join a chapter by browsing the chapters index
    Given I am on the chapters page
    When I follow "Chapters"
    And I follow "Calgary"
    And I press "Join this chapter"
    Then I should see "My Profile"
    And I should see "Calgary"

  Scenario: Join a chapter by browsing the geography
    Given I am on the geo page
    When I follow "North America"
    And I follow "Canada"
    And I follow "Alberta"
    And I follow "Calgary"
    And I press "Join this chapter"
    Then I should see "My Profile"
    And I should see "Calgary"
