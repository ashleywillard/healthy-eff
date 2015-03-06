Feature: Changing password

  As an employee
  So that I can change my account setting
  I want to be able to change my password

Background:
  Given I am logged in
    And I am on the user settings page

Scenario: Changing password - happy path
  When I fill in the “Current Password” field with my current password
  And I fill in the “New Password” field with my new password
  And I fill in the “Re-enter” field with my new password

  Then I should be on the user settings page
  And I should see a message that says “Successfully changed password”

Scenario: Changing password - sad path, wrong current password
  When I fill in the “Current Password” field with my current password
  Then I fill in the “New Password” field with my new password
  Then I fill in the “Re-enter” field with a DIFFERENT password

  Then I should be on the user settings page
  And I should see a message that says “Password mismatch”

Scenario: Changing password - sad path, wrong retyped password
  When I fill in the “Current Password” field with a WRONG password
  Then I fill in the “New Password” field with my new password
  Then I fill in the “Re-enter” field with my new password

  Then I should be on the user settings page
  And I should see a message that says “Wrong password”
  
