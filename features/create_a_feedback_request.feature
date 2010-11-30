Feature: Submit feedback/bug request
  In order to collect feedback from users
  As a user of the site
  I want to be able to provide quick feedback or bug reports

  Scenario: Submit a request
    Given a user exists
    And is logged in
    When I go to the feedback page
    And I select "Bug" from "Category"
    And I fill in "Test Subject" for "Subject"
    And I fill in "Test Message" for "Message"
    And I press "Submit"
    Then I should see "submitted successfully"
    And I should see "Test Subject"
    And I should see "Test Message"

