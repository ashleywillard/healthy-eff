Feature: Update reimbursement rate
	As an admin
	So that I can anticipate future rate changes
	I want to able to change the reimbursement rate on the current and subsequent months

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation | last_name | password_changed |
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | Fox       | true             |
  And the following admins exist:
  | email                       | password              | password_confirmation | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | true             |
  And the current rate is 10
  Given I am logged in as an admin
  And I set up the database with a few days

# Happy path
Scenario: Change rate for this month
   Given I visit the manage employee page
   When I fill in rate with "15"
   And I press “Update”
   Then I should be on the manage employee page
   And I should see "Settings were successfully updated."
   And the current rate should be "15"

# Sad path
Scenario: Add negative rate
   Given I visit the manage employee page
   When I fill in rate with "-999"
   And I press “Update”
   Then I should be on the manage employee page
   Then the current rate should be "10"

Scenario: Blank rate
	Given I visit the manage employee page
	And I press “Update”
	Then the current rate should be "10"

@javascript
Scenario: Update rate and check that calendar reflects the change
  And I update the rate to be "15"
  And I visit my calendar page
  Then I should see "$15 earned this month"
  When I click on the calendar's previous arrow
  And Cucumber needs to create click event so money changes
  Then I should see "$10 earned this month"




