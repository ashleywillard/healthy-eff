Feature: Log Healthy Activity

  As an employee
  So that I can get credit/money for exercise
  I want to log my healthy activity for the day

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation |    
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  Given I am logged in
  And I am on the home page

Scenario: Adding one exercise for 1 day
  When I fill in activity with:Running 80
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on my profile page
  And I should see "Running for 80 minutes has been recorded"

Scenario: Adding multiple exercises for a single day
  When I fill in activity with:Running 90,Lifting 100
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on my profile page
  And I should see "Running for 90 minutes has been recorded"
  And I should see "Lifting for 100 minutes has been recorded"

Scenario: Entering wrong captcha
  When I fill in a wrong captcha
  And I press “Submit”
  Then I should be on the home page
  And I should see a error message
