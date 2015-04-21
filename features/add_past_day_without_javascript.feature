Feature: Enter workout for a past day without JavaScript

  As an employee
  So that I can get credit for days I was away
  I want to be able to enter a past workout with JavaScript disabled

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | true             |
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | true             |
  Given I am logged in as a non-admin
  And I am on the past day input page

Scenario: Adding a past day
  Given I fill in day and activity with:Yesterday,Swimming 100
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on my calendar page
  And I should see activity "Swimming" and duration "100"

Scenario: Adding a past day that has already been inputted
  Given I fill in day and activity with:Yesterday,Swimming 100
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  And I am on the past day input page
  And I fill in day and activity with:Yesterday,Running 100
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see that this date has already been inputted

Scenario: Submit blank form
  Given I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see that the date is invalid

Scenario: Submit blank form with only date filled in
  Given I fill out date
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see "Duration can't be blank"

Scenario: Submit valid form with bad date
  Given I fill in day and activity with:RAWR,Swimming 100
  And I fill in reason with: "On Vacation"
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on the past day input page
  And I should see that the date is invalid
