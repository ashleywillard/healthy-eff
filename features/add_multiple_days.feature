Feature: Enter workouts for multiple days

  As an employee
  So that I can get credit for days I was away
  I want to be able to enter past workouts

Scenario: Adding multiple exercises for multiple days
  Given I am logged in
    And I am on the multiple day input page
  When I click "Add day"
  And I fill out "Activity"
  And I fill out "Date"
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on “my profile page”
  And I should see a confirmation message for multiple days
