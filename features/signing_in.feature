Feature: Signing in

  As an employee
  So that I can access my workout information
  I want to log-in to my account

Background: users in database
  Given the following users exist:
  | email                       | password              | password_confirmation |    
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  | healthypotato@gmail.com     | hotpotato             | hotpotato             |

Scenario: Logging in with the correct credentials
  Given I am on the sign in page
  When I fill in my username and password
  And I press “Log in”
  Then I should see "Signed in successfully."

Scenario: Logging in with incorrect password
  Given I am on the sign in page
  When I fill in my username and the wrong password
  And I press “Log in”
  Then I should be on the sign in page
  And I should see "Invalid email or password."

Scenario: Logging out
  Given I am logged in as a non-admin
  And I am on any page
  When I follow "Sign Out"
  Then I should be on the sign in page
