Feature: Force password change on first sign in
	As an admin
	So that I can manage my employee's information
	I want to be able to edit their names and e-mails

Background: users in database
  Given the following admins exist:
  | email                       | password              | password_confirmation | last_name | password_changed
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | Guo       | true             
  And the following users exist:
  | email                       | password              | password_confirmation | last_name | password_changed 
  | healthypotato@gmail.com     | ?Hotpotato169         | ?Hotpotato169         | Fox       | true 

Scenario: Changing name of an employee