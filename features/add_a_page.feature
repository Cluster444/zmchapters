Feature: Add a static page
  In order to provide content that is mostly static
  As an admin
  I need to be able to add static pages

  @wip
  Scenario: Add a new page
    Given an admin exists
    And is logged in
    And I am on the home page
    When I follow "Manage"
    And I press "New Page"
