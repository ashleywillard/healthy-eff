Feature: Enter workouts for past days

  As an employee
  So that I can get credit for days I was away
  I want to be able to enter past workouts

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | 
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         |
  Given I am logged in as a non-admin
  And I am on the past day input page

@javascript
Scenario: Adding multiple exercises for past days
  Given I fill in day and activity with:Yesterday,Swimming 100,Running 30|2 Days Ago,Rawring 30,Laughing 50
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on my profile page
  And I should see "Swimming for 100 minutes has been recorded"
  And I should see "Running for 30 minutes has been recorded"
  And I should see "Rawring for 30 minutes has been recorded"
  And I should see "Laughing for 50 minutes has been recorded"

@javascript
Scenario: Adding past days that have already been inputted
  Given I fill in day and activity with:Yesterday,Swimming 100,Running 30|2 Days Ago,Rawring 30,Laughing 50
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  And I am on the past day input page
  And I fill in day and activity with:Yesterday,Swimming 100,Running 30|2 Days Ago,Rawring 30,Laughing 50
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see "already been inputted"

@javascript
Scenario: Adding multiple exercises for past days with blank fields
  Given I fill in day and activity with:Yesterday,Swimming 100,Running 30|2 Days Ago,Rawring 30,Laughing 50
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see "Reason can't be blank"

@javascript
Scenario: Submit blank form
  Given I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see "Date is invalid"

@javascript
Scenario: Submit blank form with only date filled in
  Given I fill out date
  And I write the captcha text in the textbox
  And I press Submit
  Then I should be on the past day input page
  And I should see "Duration can't be blank"

@javascript
Scenario: Submit valid form with bad date
  Given I fill in day and activity with:RAWR,Swimming 100,Running 30|Meow,Rawring 30,Laughing 50
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see "Date is invalid"
