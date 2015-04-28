Feature: Recover Password
  As a user
  So that I can recover my forgotten password
  I want to be able to receive a reminder email

Background: users in database
  Given the following users exist:
  | email                       | password              | password_confirmation | password_changed |   
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | true             |
  And the current rate is 10
  
Scenario: Get email
  Given I am on the sign in page
  When I follow "Forgot your password?"
  And I fill in "healthypotato@gmail.com" into the email field
  And I press “Send me reset password instructions”
  Then I should see "You will receive an email with instructions on how to reset your password in a few minutes"

Scenario: Invalid email
  Given I am on the sign in page
  When I follow "Forgot your password?"
  And I fill in "meow@meow.com" into the email field
  And I press “Send me reset password instructions”
  And I should see "Email not found"
  And I should be on the forgot password page
