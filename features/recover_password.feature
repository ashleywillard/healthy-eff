Feature: Recover Password
  As a user
  So that I can recover my forgotten password
  I want to be able to receive a reminder email

Background
  Given I am logged in as Joe Smith

Scenario: Get email
  When I click “Forgot my password”
  And I type in "joesmith@healthy.com" into the email field
  And I click "Submit"
  Then I should see “An email has been sent”

Scenario: Invalid email
  When I click “Forgot my password” 
  And I type in "meow@meow.com" into the email field
  And I click "Submit"
  Then I should see “Invalid email”
  And I should be on the forgot password page
