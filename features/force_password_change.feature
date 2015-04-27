Feature: Force password change on first sign in

  As an administrator
  So that I can ensure password security
  I want to have users change their password the first time they log in

Scenario: User has not yet changed password
  Given that I sign in as a new user
  Then I should be on the user settings page
  And I should be welcomed

Scenario: User has already changed password
  Given that I sign in as a returning user
  Then I should see "Signed in successfully."

Scenario: User does not provide new password and presses "Update"
  Given that I sign in as a new user
  When I provide my current password
  And I hit "Update"
  Then I should be on the user settings page
  And I should be welcomed

Scenario: User provides new password and presses "Update"
  Given that I sign in as a new user
  When I provide my current password
  And I type in a new password and confirm it
  And I hit "Update"
  Then I should see "Your account has been updated successfully."
