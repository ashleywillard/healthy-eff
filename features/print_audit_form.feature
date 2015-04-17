Feature: Print audit form

As an admin
So that I am able to add money to employee paychecks
I want to be able to print out audit forms for payroll

Background:
  Given the following admins exist:
  | email                       | password              | password_confirmation | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | true             |
  And "Nick Herson" and "Armando Fox" exist as users
  And I have logged 4 activities

Scenario: Print audit form
  Given I am logged in as an admin
  And I visit the admin page
  When I follow the PDF button "Print Audit Sheet"
  Then the following names should be listed on the audit form: "Herson"
