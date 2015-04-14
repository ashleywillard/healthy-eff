Feature: Print audit form

As an admin
So that I am able to add money to employee paychecks
I want to be able to print out audit forms for payroll

Background:
Given "Nick Herson" and "Armando Fox" exist as users

Scenario: Print audit form
Given I am logged in as an admin
And I am on the admin view
When I press print audit form
Then the following names should be listed on the audit form: Armando, Nick
