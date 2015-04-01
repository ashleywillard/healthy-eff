Feature: Recover Password
  As a user
  So that I can recover my forgotten password
  I want to be able to receive a reminder email

Background: users in database
  Given the following users exist:
  | email                       | password              | password_confirmation |    
  | healthypotato@gmail.com     | hotpotato             | hotpotato             |

@javascript
Scenario: Get email
  When I follow "Forgot your password?"
  And I fill in "healthypotato@gmail.com" into the email field
  And I click "Submit"
  Then I should be on the home page
  And I should see “An email has been sent”

@javascript
Scenario: Invalid email
  When I follow "Forgot your password?" 
  And I fill in "meow@meow.com" into the email field
  And I click "Submit"
  Then I should see “Invalid email”
  And I should be on the forgot password page
