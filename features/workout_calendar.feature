Feature: Workout Calendar
  As a user
  So that I can see how many days I worked out this month
  I want to see a calendar with days marked when I worked out

Background: users in database
  Given the following users exist:
  | email                       | password              | password_confirmation | last_name |  
  | healthypotato@gmail.com     | hotpotato             | hotpotato             | Fox       |

Scenario: Visiting my user profile page
  Given I am logged in as a non-admin
  And I am on any page
  When I follow "Profile"
  Then I should be on my profile page
  And I should see a calendar with my logged activities

Scenario: Viewing previous months
  Given I am logged in as a non-admin
  And I am on my profile page
  And I click on the name of the month in the calendar
  Then I should see options for previous months
  And when I click on a previous month
  And I press “Refresh”
  Then I should see ........
