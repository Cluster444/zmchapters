Feature: Join a chapter
  In order to get involved with the movement
  As a volunteer
  I need to be able to join a chapter

  Scenario: Join a chapter
    Given I am a new, authenticated member
    And I have a city chapter named "Calgary" in "Alberta, Canada, North America"
    And I am on the chapters page
    When I follow "Chapters"
    And I follow "Calgary"
    And I press "Join this chapter"
    Then I should see "My Profile"
    And I should see "You have joined the Calgary chapter"
