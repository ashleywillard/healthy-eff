Feature: Force password change on first sign in
	As an admin
	So that I can manage my employee's information
	I want to be able to edit their names and e-mails

Background: users in database
  Given the following admins exist:
  | email                       | password              | password_confirmation | last_name | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | Guo       | true             |
  And the following users exist:
  | email                       | password              | password_confirmation | last_name | password_changed |
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | Fox       | true             |
  Given I am logged in as an admin
  When I visit the manage employee page

Scenario: Changing first name of an employee
  When I follow "Edit"
  And I fill in first name with "Armando"
  And I press “Update”
  Then I should see "Armando"
  And I should see "User settings successfully changed"

Scenario: Changing last name
  When I follow "Edit"
  And I fill in last name with "the Professor"
  And I press “Update”
  Then I should see "the Professor"
  And I should see "User settings successfully changed"

Scenario: Changing email
  When I follow "Edit"
  And I fill in email with "meow@meow.com"
  And I press “Update”
  Then I should see "meow@meow.com"
  And I should see "User settings successfully changed"
  