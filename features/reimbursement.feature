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
   When I fill in "15"
   And I click "Change rate"
   Then I should see "Rate changed to 15"
   And I go to "Admin home" page
   And I should see "15"

# Sad path
Scenario: Add negative rate
   Given I visit the manage employee page
   When I fill in "-999"
   And I click "Change rate"
   Then I should see "Invalid rate"

Scenario: Blank rate
	Given I visit the manage employee page
	When I click "Change rate"
	Then I should see "Rate can't be blank"





