Feature: Recover Password
  As a user
  So that I can recover my forgotten password
  I want to be able to receive a reminder email

Scenario: Get e-mail
  When I click “Forgot my password”
  And I type in my email
  And I click submit
  Then I should see “An email has been sent”


Scenario: Invalid email
  When I click “Forgot my password” 
  And I type in a BAD email
  And I click submit
  Then I should see “Invalid email”
  And I should be on the forgot password page