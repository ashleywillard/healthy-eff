Feature: Update reimbursement rate
	As an admin
	So that I can anticipate future rate changes
	I want to able to change the reimbursement rate on the current and subsequent months

Background:
  Given the following admins exist:
  | email                       | password              | password_confirmation | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | true             |
  And the current rate is 10
  Given I am logged in as an admin

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





