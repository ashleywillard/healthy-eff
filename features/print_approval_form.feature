Feature: Print workout approval forms

As an admin
So that my employees can sign off on what they did
I want to be able to print out approval forms

Background:
  Given That Person1 has logged 4 activities
  And This Person2 has logged 1 activities


Scenario: Selectively Printing Approval Forms
Given I am logged in as an admin
And I am on the admin view
When I check names: 
Then I press print forms
Then I should see a print preview and a form for: blah1, blah2, blah3
And I should not see a print preview and a form for: blah4, blah3
