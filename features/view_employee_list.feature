Feature: View Employee List
  As an admin
  So that I can keep track of all employees logged activities for this month
  I want to see a display of all employees and how many days 

Background:
  Given I am logged in
  And I am an admin

Scenario: Admin view
  When I click on the admin view
  I should see a list of employee names
  And I should see the number of days each employee worked out
  And I should see the amount of money each employee has accumulated

Scenario: Visiting the pending approval page
  When I press “Pending Approval”
  I should be on the “Pending Approval” page

Scenario: Viewing for a particular month
  When I click on the month
  I should see options for previous months
  And when I click on a previous month
  And I press “Refresh”
  Then I should see a list of employee names etc. for that month