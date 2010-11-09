Feature: Manage Chapters
  In order to make a chapter network site
  As an administrator
  I want to create and manage chapters

  Scenario: Chapters List
    Given I have chapters named Calgary, Edmonton
    When I go to the list of chapters
    Then I should see "Calgary"
    And I should see "Edmonton"
