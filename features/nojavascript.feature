Feature: Update reimbursement rate
	As a user and admin
	So that my javascript-less devices still work
	I want to be able to view my calendar without javascript

Background: users in database
  Given the following admins exist:
  | email                       | password              | password_confirmation | last_name | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | Guo       | true             |
  And the following users exist:
  | email                       | password              | password_confirmation | last_name | password_changed |
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | Fox       | true             |

Scenario: Still see calendar without javascript
   Given I am logged in as a non-admin
   When I visit my calendar page
   Then I should see my name
   And I should see the weeks

Scenario: Still can click menu tabs
   Given I am logged in as an admin
   Then I should see "Admin Home"
   And I should see "Manage Employees"
   And I should see "Edit"
   And I should see "Sign Out"

Scenario: Still can sort employees
   Given I am logged in as an admin
   When I visit the admin home page
   And I click "Last Name"
   Then I should see "Fox" before "Guo"

