Feature: Workout Calendar
  As a user
  So that I can see how many days I worked out this month
  I want to see a calendar with days marked when I worked out

Background: users in database
  Given the following users exist:
  | email                       | password              | password_confirmation |
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  | healthypotato@gmail.com     | hotpotato             | hotpotato             |

  Given I am logged in as a non-admin
  And I set up the database with a few days

@javascript
Scenario: Visiting my user profile page
  When I follow "Profile"
  Then I should be on my profile page
  And I should see a calendar with my logged activities
  And I should not see the previous months logged activities

@javascript
Scenario: Viewing previous months
  When I follow "Profile"
  Then I should be on my profile page
  When I click on the calendar's previous arrow
  Then I should see a calendar with my last months logged activities
