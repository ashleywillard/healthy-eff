Feature: Print workout approval forms

As an admin
So that my employees can sign off on what they did
I want to be able to print out approval forms

Scenario: Selectively Printing Approval Forms
Given I am logged in as an admin
And I am on the admin view
When I check names: blah1, blah2, blah3
And I uncheck names: blah4, blah5
Then I press print forms
Then I should see a print preview and a form for: blah1, blah2, blah3
And I should not see a print preview and a form for: blah4, blah5
