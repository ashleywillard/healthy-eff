Feature: Adding and removing employees

  As an admin
  So that new employees can track their workout
  I want to be able to register employees

Background: users in database
  Given the following admins exist:
  | email                       | password              | password_confirmation | last_name |  
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       | Guo       |
  Given the following users exist:
  | email                       | password              | password_confirmation | last_name |  
  | healthypotato@gmail.com     | hotpotato             | hotpotato             | Fox       |

Scenario: Going to add employee page
  Given I am logged in as an admin
  And I visit the manage employee page
  When I follow “Add a new employee”
  Then I should be on the add employee page

Scenario: Adding an employee
  Given I am logged in as an admin
  And I visit the manage employee page
  And I visit the add employee page
  And I fill in email with "newpotato@gmail.com"
  And I press “Send an invitation”
  Then I should see "An invitation email has been sent"

Scenario: Removing an employee
  Given I am logged in as an admin
  And I visit the manage employee page
  And I press “Delete”
  Then I should be on the manage employee page
  And I should see "User '' 'Fox' deleted."

Scenario: Not an admin
  Given I am logged in as a non-admin
  And I visit the manage employee page
  Then I should be on the home page
  And I should see "Access to this page is restriced to administrators."

Scenario: Can't delete myself
  Given I am logged in as an admin
  And I visit the manage employee page
  Then I should not see "Guo"
