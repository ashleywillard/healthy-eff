Feature: Adding and removing employees

  As an admin
  So that new employees can track their workout
  I want to be able to register employees

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation |    
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  | healthypotato@gmail.com     | hotpotato             | hotpotato             |

Scenario: Going to add employee page
  Given I am an admin
  And I go to the manage employee page
  When I follow “Add a new employee”
  Then I should be on the add employee page

Scenario: Adding an employee
  Given I am an admin
  And I go to the add employee page
  When I fill in "" with John Doe
  And I fill in johndoe@healthy.com in the email input box
  And I press "Submit"
  Then I should be on the manage employee page

Scenario: Removing an employee
  Given I am an admin
  And I go to the manage employee page
  When I follow the "Remove" link for John Doe
  And I press OK
  Then I should be on the manage employee page
  And I should not see "John Doe"

Scenario: Not an admin
  Given I am a nonadmin
  And I visit "Manage Employees"
  Then I should be on the home page
  And I should see "You are not authorized to send invites"

Scenario: Can't delete myself
  Given I am an admin
  And I am on the manage employee page
  Then I should not see my name
