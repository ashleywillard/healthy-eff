Feature: Print audit form
As an admin
So that I am able to add money to their paycheck monthly
I want to be able to print out audit forms for payroll
Difficulty: 5

Scenario: Print audit form
Given I am logged in and on the admin view
And the following users exist: Armando, Nick
When I press print audit form
Then the following names should be listed on the audit form: Armando, Nick
