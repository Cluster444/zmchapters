Feature: Manage a page
  In order to maintain my static content
  As an admin
  I need to be able to modify the page content

  @admin
  Scenario: Manage a page without js
    Given an admin exists
    And is logged in
    And a page exists with title: "Protocols 1.0", uri: "protocols"
    When I go to the protocols page
    And I press "Edit Protocols"
    And I fill in "Protocols 1.1" for "page_title"
    And I fill in "Content" for "page_content"
    And I press "Save"
    Then I should see "updated successfully"
    And I should see "Protocols 1.1"
    And I should see "Content"
  
  #@wip
  Scenario Outline: Restrict access to the edit page
    Given a user exists
    And is <status>
    And a page exists with uri: "protocols"
    When I go to the edit protocols page
    Then I should be on the <page>
    And I should see "not authorized"

    Examples:
      | status        | page           |
      | not logged in | the login page |
      | logged in     | the home page  |
