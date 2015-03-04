Feature: Enter workouts for multiple days

  As an employee
  So that I can get credit for days I was away
  I want to be able to enter past workouts

Scenario: Adding multiple exercises for multiple days
  Given I am logged in and on “the multiple day input page”
  When I click add day
  And I fill out activity
  And I fill out date 
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on “my profile page”
  And I should see a confirmation flash message for multiple days
