Feature: Create a chapter
  In order to allow members to start new chapters
  As an admin
  I need to be able to create new chapters
  
  Background:
    Given a location exists for "Alberta, Canada, North America"

  Scenario: Create a country chapter
    Given an admin exists
    And is logged in
    When I go to the Canada geo page
    And I follow "Create Chapter"
    Then the "Name" field should contain "Canada"
    And "Canada" should be selected for "geo_country_id"
    # And I should not see a territory field
    And the "Category" field should contain "country"
    When I press "Save"
    Then I should be on the "Canada" chapter page

  Scenario: Create a subchapter
    Given an admin exists
    And is logged in
    When I go to the Alberta geo page
    And I follow "Create Chapter"
    Then "Canada" should be selected for "geo_country_id"
    And "Alberta" should be selected for "geo_id"
    When I fill in "Alberta" for "Name"
    When I select "Province" from "Category"
    And I press "Save"
    Then I should be on the "Alberta" chapter page

  Scenario: Hide admin controls from non admin
    Given a user exists
    And is logged in
    When I go to the Canada geo page
    Then I should not see "Create Chapter"
    When I go to the Alberta geo page
    Then I should not see "Create Chapter"

  Scenario: Hide controls from country after country chapter is created
    Given an admin exists
    And is logged in
    And a country chapter exists for "Canada" in "Canada"
    When I go to the Canada geo page
    Then I should not see "Create Chapter"
