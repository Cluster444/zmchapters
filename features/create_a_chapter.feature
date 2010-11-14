Feature: Create a chapter
  In order to allow members to start new chapters
  As an admin
  I need to be able to create new chapters

  Scenario: Create a country chapter
    Given an admin exists
    And is logged in
    And a location exists for "Canada, North America"
    When I go to the geo page
    And I follow "North America"
    And I follow "Canada"
    And I press "Create Chapter"
    Then I should see "Canada"
    #And I should be on the "Canada" chapter page

  Scenario: Create a subchapter
    Given an admin exists
    And is logged in
    And a location exists for "Alberta, Canada, North America"
    When I go to the geo page
    And I follow "North America"
    And I follow "Canada"
    And I follow "Alberta"
    And I fill in "Alberta" for "chapter_name"
    And I select "province" from "chapter_category"
    And I press "Create Chapter"
    Then I should see "Alberta"
    #And I should be on the "Alberta" chapter page
