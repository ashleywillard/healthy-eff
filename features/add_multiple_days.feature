Feature: Enter workouts for multiple days

  As an employee
  So that I can get credit for days I was away
  I want to be able to enter past workouts

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation |    
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  Given I am logged in
  And I am on the multiple day input page


Scenario: Adding multiple exercises for multiple days
  When I click "Add day"
  And I click "Add Activity"
  And I fill in activity with: Swimming 100
  And I fill in date with: 3/10/2015
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on “my profile page”
  And I should see a confirmation message for multiple days
