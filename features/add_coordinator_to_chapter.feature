Feature: Add a coordinator to a chapter
  In order to allow individuals to help maintain and organize the site
  As an adminstrator
  I need to be able to assign users as coordinators of chapters.

  Scenario: Make an existing user a coordinator of an existing chapter
    Given a user exists with name: "Joe"
    And an admin exist
    And is logged in
    And a location exists for "Alberta, Canada, North America"
    And a city chapter exists for "Calgary" in "Alberta"
    When I go to the "Calgary" chapter page
    And I follow "Add a Coordinator"
    And I select "Joe" from "coordinator_user_id"
    And I press "Save"
    Then I should be on the "Calgary" chapter page
    And I should see "Joe"
