Feature: Changing password

  As an employee
  So that I can change my account setting
  I want to be able to change my password

Background: users in database
  Given the following users exist:
  | email                       | password              | password_confirmation |
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  | healthypotato@gmail.com     | hotpotato             | hotpotato             |
  Given I am logged in as a non-admin
  And I am on the user settings page

Scenario: Changing password - happy path
  When I fill in the user_email field with my email
  And I fill in the user_password field with my new password
  And I fill in the user_password_confirmation field with my new password
  And I fill in the user_current_password field with my old password
  And I press “Update”

  # Then I should be on the today page
  And I should see "Your account has been updated successfully."

Scenario: Changing password - sad path, wrong current password
  When I fill in the user_email field with my email
  And I fill in the user_password field with my new password
  And I fill in the user_password_confirmation field with a DIFFERENT password
  And I fill in the user_current_password field with my old password
  And I press “Update”

  Then I should be on the user settings page
  And I should see "Password doesn't match confirmation"

Scenario: Changing password - sad path, wrong retyped password
  When I fill in the user_email field with my email
  And I fill in the user_password field with my new password
  And I fill in the user_password_confirmation field with my new password
  And I fill in the user_current_password field with a BAD old password
  And I press “Update”

  Then I should be on the user settings page
  And I should see "Current password is invalid"
