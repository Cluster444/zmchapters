Feature: Create a chapter
  In order to allow members to start new chapters
  As an admin
  I need to be able to create new chapters
  
  Background:
    Given a location exists for "Alberta, Canada, North America"

  Scenario: Create a country chapter
    Given an admin exists
    And is logged in
    When I go to the geo page
    And I follow "North America"
    And I follow "Canada"
    Then I should see a create chapter form
    When I press "Create Chapter"
    Then I should see "Canada"
    #And I should be on the "Canada" chapter page

  Scenario: Create a subchapter
    Given an admin exists
    And is logged in
    When I go to the geo page
    And I follow "North America"
    And I follow "Canada"
    And I follow "Alberta"
    Then I should see a create chapter form
    When I fill in "Alberta" for "chapter_name"
    And I select "Province" from "chapter_category"
    And I press "Create Chapter"
    Then I should see "Alberta"
    #And I should be on the "Alberta" chapter page

  Scenario: Hide admin controls from non admin
    Given a user exists
    And is logged in
    When I go to the geo page
    And I follow "North America"
    And I follow "Canada"
    Then I should not see a create chapter form
    When I follow "Alberta"
    Then I should not see a create chapter form

  Scenario: Hide controls from country after country chapter is created
    Given an admin exists
    And is logged in
    When I go to the geo page
    And I follow "North America"
    And I follow "Canada"
    And I press "Create Chapter"
    Then a chapter should exist
    When I go to the geo page
    And I follow "North America"
    And I follow "Canada"
    Then I should not see a create chapter form
