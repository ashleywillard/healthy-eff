Feature: Print workout approval forms

As an admin
So that my employees can sign off on what they did
I want to be able to print out approval forms

Background:
  Given the following admins exist:
  | email                       | password              | password_confirmation | password_changed |
  | 169.healthyeff@gmail.com    | ?Northsidepotato169   | ?Northsidepotato169   | true             |
  And the current rate is 10
#   And That Person1 has logged 4 activities
#   And This Person2 has logged 1 activities
  And Nick Herson has logged 4 activities
  And Armando Fox has logged 1 activity


@javascript
Scenario: Selectively Printing Approval Forms
  Given I am logged in as an admin
  And I am on the admin view
  When I select all
  And I hit "Print Selected"
  Then I should see "Herson"
