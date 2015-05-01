Feature: Adding and removing employees

  As an admin
  So that new employees can track their workout
  I want to be able to register employees

Background: users in database
  Given the following admins exist:
  | email                       | password              | password_confirmation | last_name | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | Guo       | true             |

  And the following users exist:
  | email                       | password              | password_confirmation | last_name | first_name | password_changed |
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | Fox       | Armando    | true             |

  And the current rate is 10

Scenario: Going to add employee page
  Given I am logged in as an admin
  And I visit the manage employee page
  When I follow “New employee”
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
  And I follow "Delete"
  Then I should be on the manage employee page
  And I should see that "Armando" "Fox" has been deleted

Scenario: Not an admin
  Given I am logged in as a non-admin
  And I visit the manage employee page
  Then I should be on the home page
  And I should see that I cannot access this page

Scenario: Can't delete myself
  Given I am logged in as an admin
  And I visit the manage employee page
  Then I should not see "Guo"

Scenario: Sorting employees
  Given I am logged in as an admin
  And the following users exist:
  | email                       | password              | password_confirmation | last_name | first_name | password_changed |
  | abcdefghijklm@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | Doe       | John       | true             |

  When I visit the manage employee page
  And I follow "First Name"
  Then "Armando" should appear before "John"
  When I follow "Last Name"
  Then "Doe" should appear before "Fox"
