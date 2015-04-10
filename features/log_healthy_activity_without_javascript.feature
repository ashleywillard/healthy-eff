Feature: Log Healthy Activity Without JavaScript

  As an employee
  So that I can get credit/money for exercise
  I want to log my healthy activity with JavaScript disabled

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation |    
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  | healthypotato@gmail.com     | hotpotato             | hotpotato             |
  Given I am logged in as a non-admin
  And I am on the home page

Scenario: Adding one exercise
  When I fill in activity with:Running 80
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on my profile page
  And I should see "Running for 80 minutes has been recorded"

Scenario: Adding today multiple times
  When I fill in activity with:Running 90
  And I write the captcha text in the textbox
  And I press “Submit”
  And I am on the home page
  When I fill in activity with:Running 90
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "already been inputted"

Scenario: Adding one exercise without duration
  When I fill in activity with:Running 
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Duration can't be blank"

Scenario: Adding one exercise with less than 0 minutes
  When I fill in activity with:Running -1
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Duration can't be less than 0"

Scenario: Adding one exercise with greater than 1440 minutes
  When I fill in activity with:Running 1441
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Duration can't be over 24 hours"

Scenario: Adding one exercise with less than 60 minutes
  When I fill in activity with:Running 30
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Total can't be less than 60"

Scenario: Submitting a blank form
  When I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Duration can't be blank"