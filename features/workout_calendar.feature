Feature: Workout Calendar
  As a user
  So that I can see how many days I worked out this month
  I want to see a calendar with days marked when I worked out

Background: users in database
  Given the following users exist:
  | email                       | password              | password_confirmation | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | true             |
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | true             |
  And the current rate is 10
  Given I am logged in as a non-admin
  And I set up the database with a few days
  And I visit my calendar page

@javascript
Scenario: Visiting my user calendar page
  When I follow Calendar
  Then I should be on my calendar page
  And I should see a calendar with my logged activities
  And I should see "$10 earned this month"
  And I should not see the previous months logged activities

@javascript
Scenario: Viewing previous months
  When I click on the calendar's previous arrow
  Then I should see a calendar with my last months logged activities
  And I should see "$10 earned this month"

@javascript
Scenario: Cannot click arrow to see future months on calendar
  Then I should not be able to click next
  And I should be able to click prev

@javascript
Scenario: Cannot click arrow to see months before your first workout
  Then I click on the calendar's previous arrow
  Then I should not be able to click prev
  And I should be able to click next