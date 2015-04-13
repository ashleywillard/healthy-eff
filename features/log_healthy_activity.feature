Feature: Log Healthy Activity Without Javascript

  As an employee
  So that I can get credit/money for exercise
  I want to log my healthy activity for the day

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | 
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         |
  Given I am logged in as a non-admin
  And I am on the home page

@javascript
Scenario: Adding one exercise
  When I fill in activity with:Running 80
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on my profile page
  And I should see "Running for 80 minutes has been recorded"

@javascript
Scenario: Adding multiple exercises
  When I fill in activity with:Running 90,Lifting 100
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on my profile page
  And I should see "Running for 90 minutes has been recorded"
  And I should see "Lifting for 100 minutes has been recorded"

@javascript
Scenario: Adding today multiple times
  When I fill in activity with:Running 90,Lifting 100
  And I write the captcha text in the textbox
  And I press “Submit”
  And I am on the home page
  When I fill in activity with:Running 80
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "already been inputted"

@javascript
Scenario: Adding one exercise without duration
  When I fill in activity with:Running 
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Duration can't be blank"

@javascript
Scenario: Adding one exercise with less than 0 minutes
  When I fill in activity with:Running -1
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Duration can't be less than 0"

@javascript
Scenario: Adding one exercise with greater than 1440 minutes
  When I fill in activity with:Running 1441
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Duration can't be over 24 hours"

@javascript
Scenario: Adding multiple exercises with total greater than 1440 minutes
  When I fill in activity with:Running 1430,Hockey 11
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Total can't be more than 24 hours"

@javascript
Scenario: Adding one exercise with less than 60 minutes
  When I fill in activity with:Running 30
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Total can't be less than 60"

@javascript
Scenario: Submitting a blank form
  When I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Duration can't be blank"

@javascript
Scenario: Adding multiple exercises with less than 60 minutes total
  When I fill in activity with:Running 20,Crying 10
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the home page
  And I should see "Total can't be less than 60"
