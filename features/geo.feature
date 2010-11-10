Feature: Geography Navigation
  In order to find chapter information
  As a member or coordinator
  I want to be able to browse chapters by geography

  Scenario: Navigation
    Given I have geography
    When I go to the continent list
    Then I should see "Continent"
    When I follow "Continent"
    Then I should see "Country"
    When I follow "Country"
    Then I should see "Territory"
