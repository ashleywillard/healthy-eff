Feature: View Employee List

  As an admin
  So that I can keep track of all employees logged activities for this month
  I want to see a display of all employees and the number of days they have logged activities for this month

Background:
  Given the following admins exist:
  | email                       | password              | password_confirmation |
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  And I am logged in as an admin

Scenario: Admin view
  When I follow "Admin"
  Then I should see a list of employee names
  And I should see the number of days each employee worked out

Scenario: Visiting the pending approval page
  When I press “Pending"
  Then I should be on the pending approval page

Scenario: Viewing for a particular month
  When I click on the month
  Then I should see options for previous months
  And when I click on a previous month
  And I press “Refresh”
  Then I should see a list of employee names etc. for that month
