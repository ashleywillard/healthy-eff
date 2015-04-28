Feature: Mark accounting forms as received
	As an admin
	So that I can check who has turned in their accounting forms
	I want to be able to mark each employee's form as received

Background:
  Given the following admins exist:
  | email                       | password              | password_confirmation | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | true             |
  And the current rate is 10
  And Nick Herson has logged 4 activities

Scenario: Sad path; no users selected
   Given I am logged in as an admin
   When I visit the admin home page
   When I hit "Mark Received"
   Then I should be on the admin list view
   And I should not see "✓"

@javascript
Scenario: Happy path; users selected
   Given I am logged in as an admin
   When I visit the admin home page
   When I select all
   And I hit "Mark Received"
   Then I should be on the admin list view
   And I should see "Forms marked"
   And I should see "✓"
