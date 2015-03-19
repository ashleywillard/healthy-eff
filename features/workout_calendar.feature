Feature: Workout Calendar
  As a user
  So that I can see how many days I worked out this month
  I want to see a calendar with days marked when I worked out

Scenario: Visiting my user profile page
  Given that I am logged in and on any page
  When I click my user profile link
  I should be on “my profile page”
  And I should see a calendar with my logged activities

Scenario: Viewing previous months
  When I click on the name of the month in the calendar
  I should see (a dropdown menu?) options for previous months
  And when I click on a previous month
  And I press “Refresh”
  Then I should see a list of employee names etc. for that month