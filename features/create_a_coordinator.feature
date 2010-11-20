Feature: Create a new coordinator
  In order to help organize the chapter network
  As an admin
  I need to be able to make a member a coordinator for a chapter

  Scenario: Assign a user as a coordinator
    Given an admin exists
    And is logged in
    And a user exists with name: "Bob Brown", username: "bob"
    And a location exists for "Alberta, Canada, North America"
    And a city chapter exists for "Calgary" in "Alberta"
    When I follow "Create Coordinator"
    And I select "Bob Brown (bob)" from "coordinator_user_id"
    And I select "Calgary" from "coordinator_chapter_id"
    And I press "Create"
    Then I should see "Calgary"
    And I should see "Bob Brown (bob)"

  @wip
  Scenario: Assign a user as a coordinator from a user page

  @wip
  Scenario: Assign a user as a coordinator from the chapter page

  Scenario Outline: Deny access to non admins
    Given a user exists
    And is <status>
    When I go to the new coordinator page
    Then I should be on the <page>
    And I should see "not authorized"

    Examples:
      | status        | page       |
      | logged in     | home page  |
      | not logged in | login page |

