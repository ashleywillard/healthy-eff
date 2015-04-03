Feature: Enter workouts for past days

  As an employee
  So that I can get credit for days I was away
  I want to be able to enter past workouts

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation |    
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  | healthypotato@gmail.com     | hotpotato             | hotpotato             |
  Given I am logged in as a non-admin
  And I am on the past day input page

@javascript
Scenario: Adding multiple exercises for past days
  And I fill in day and activity with:Yesterday,Swimming 100,Running 30|2 Days Ago,Rawring 30,Laughing 50
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on my profile page
  And I should see "Swimming for 100 minutes has been recorded"
  And I should see "Running for 30 minutes has been recorded"
  And I should see "Rawring for 30 minutes has been recorded"
  And I should see "Laughing for 50 minutes has been recorded"

@javascript
Scenario: Adding multiple exercises for past days with blank fields
  And I fill in day and activity with:Yesterday,Swimming 100,Running 30|2 Days Ago,Rawring 30,Laughing 50
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see "Reason can't be blank"


@javascript
Scenario: Submit blank form
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see "Fields are empty"


@javascript
Scenario: Submit blank form with only date filled in
  And I click Add Day
  And I fill out date
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see "Fields are empty"

@javascript
Scenario: Submit valid form with bad date
  And I fill in day and activity with:RAWR,Swimming 100,Running 30|Meow,Rawring 30,Laughing 50
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see "Date is invalid"

