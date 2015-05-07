Feature: Adjusting to Client Timezone

  As an employee
  So that I enter workouts in different time zones
  I want to be able to save the correct date I worked out

Background:
  Given the following users exist:
  | email                       | password              | password_confirmation | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | true             |
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | true             |
  And the current rate is 10
  Given I am logged in as a non-admin
  And I am on the home page
  Then I should see "Pacific Time (US & Canada)"

@javascript
Scenario: Changing Timezone on Settings Page
  Given I am on the user settings page
  And I select timezone "Tijuana"
  Then I should see "Settings were successfully updated."
  When I am on the home page
  Then I should see "Tijuana"
