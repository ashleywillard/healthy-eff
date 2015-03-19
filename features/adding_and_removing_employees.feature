Feature: Adding and removing employees
  As an admin
  So that new employees can track their workout
  I want to be able to register employees

Background:
  Given I am logged in
  And I am an admin

Scenario: Going to add employee page
  Given I am on the manage employee page
  And I click “Add employee”
  Then I should be on the add employee page

Scenario: Adding an employee
  Given I am on the add employee page
  And I fill in John Doe into the name input box
  And I fill in johndoe@healthy.com in the email input box
  And I press submit
  Then I should be on the manage employee page

Scenario: Removing an employee
  Given I am on the manage employee page
  And I follow the "Remove" link for John Doe
  And I press OK
  Then I should be on the manage employee page
  And I should not see "John Doe"