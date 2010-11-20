Feature: Update a site option
  In order to manage the site
  As an admin
  I need to be able to update site options

  Scenario: Update an option
    Given an admin exists
    And is logged in
    And a site_option exists with key: "option_a", value: "Value A"
    When I go to the site options page
    And I follow "edit_option_a"
    And I fill in "Value A.2" for "Value"
    And I press "Save"
    Then I should be on the site options page
    And I should see "updated successfully"
    And I should see "Value A.2"

  Scenario Outline: Deny access to non admins
    Given a user exists
    And is <status>
    When I go to the site options page
    Then I should be on the <page>
    And I should see "not authorized"
    
    Examples:
      | status        | page       |
      | logged in     | home page  |
      | not logged in | login page |
