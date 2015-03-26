Feature: Approve late submissions

  As an admin
  So that employees can get credit for their past workouts
  I want to be able to approve these submissions

Background:
  Given I am logged in as an admin

Scenario: Selective Approval
  Given I am on the pending approval page
  When I check the following names: Mary, Joe, Bob
  And I uncheck: Olivia, Kate
  And I click “Approve”
  Then I should be on the admin page
  And I should see a approval flash message
  And I should see Mary, Joe, Bob
  And I should not see Olivia, Kate
