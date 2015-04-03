Feature: View Employee List

  As an admin
  So that I can keep track of all employees logged activities for this month
  I want to see a display of all employees and the number of days they have logged activities for this month

Background:
  Given the following admins exist:
  | email                       | password              | password_confirmation |
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  And the following users exist:
  | email                      | password        | password_confirmation |
  | healthypotato@gmail.com    | hotpotato       | hotpotato             |

Scenario: Admin toolbar links
  Given I am logged in as a non-admin
  Then I should not see the "Admin" link
  And I should not see the "Pending" link

Scenario: Admin view
  Given I am logged in as an admin
  When I follow "Admin"
  Then I should see a table of employee names
  And I should see the number of days each employee worked out

Scenario: No pending activities
  Given I am logged in as an admin
  And no pending activities exist
  Then I should not see the "Pending" link
  When I visit the pending approval page
  Then I should be on the admin list page
  And I should see "No activities pending approval"

Scenario: Pending activities
  Given 2 pending activities exist
  And I am logged in as an admin
  Then I should see "2 Pending"
  When I visit the pending approval page
  Then I should be on the pending approval page
  And there should be 2 activities pending approval

Scenario: Viewing for a particular month
  Given I am logged in as an admin
  And I am on the admin list page
  When I click on the month
  Then I should see options for previous months
  And when I click on a previous month
  And I press “Refresh”
  Then I should see a list of employee names etc. for that month
