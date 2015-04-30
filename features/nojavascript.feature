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
  And the current rate is 10
  And I set up the database with a few days
  
Scenario: Still see calendar without javascript
   Given I am logged in as a non-admin
   When I visit my calendar page
   Then I should see a table with workouts from the current month
   And I should see a table with workouts from the previous month

Scenario: Still can sort employees
   Given I am logged in as an admin
   And Armando Fox has logged 2 activities
   And Will Guo has logged 3 activities
   When I visit the admin list page
   And I follow "Last Name"
   Then "Fox" should appear before "Guo"
