Feature: Site Navigation
  In order to make the site easy to use
  As a browser of the site
  I want to be able to find my way around

  Scenario: Home Page
    Given I am on the home page
    Then I should see "Home"
    And I should see "Chapters"
    And I should see "Member"
  
  Scenario: Home Page to Chapters
    Given I am on the home page
    When I follow "Chapters"
    Then I should see "Chapters Index"

  Scenario: HomePage to Members
    Given I am on the home page
    When I follow "Members"
    Then I should see "Members Index"

  Scenario: Sign in
    Given I am on the home page
    When I follow "Sign In"
    Then I should see "Sign In"
