Feature: View Employee List

  As an admin
  So that I can keep track of all employees logged activities for this month
  I want to see a display of all employees and the number of days they have logged activities for this month

Background:
  Given the following admins exist:
  | email                       | password              | password_confirmation | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | true             |
  And the following users exist:
  | email                      | password        | password_confirmation | password_changed |
  | healthypotato@gmail.com    | ?Hotpotato169   | ?Hotpotato169         | true             |

Scenario: Privileged access
  Given I am logged in as a non-admin
  Then I should not see the "Admin" link
  And I should not see the "Pending" link
  When I visit the admin list page
  Then I should be on the home page
  And I should see "You don't have permission to access this."

Scenario: Admin list view
  Given that I have logged 3 activities
  And I am logged in as an admin
  When I follow "Admin"
  And I follow "Admin Home"
  Then I should see a table of employee names
  And I should see "Days"
