Feature: Approve late submissions

  As an admin
  So that employees can get credit for their past workouts
  I want to be able to approve these submissions

Background:
  Given the following admins exist:
  | email                       | password              | password_confirmation |
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  And the following users exist:
  | email                      | password        | password_confirmation |
  | healthypotato@gmail.com    | hotpotato       | hotpotato             |

Scenario: Privileged access
  Given I am logged in as a non-admin
  Then I should not see "Pending"
  When I visit the pending approval page
  Then I should be on the home page
  And I should see "Access to this page is restriced to administrators."

Scenario: No pending activities
  Given I am logged in as an admin
  And no pending activities exist
  Then I should not see the "Pending" link
  When I visit the pending approval page
  Then I should be on the admin list page
  And I should see "No activities pending approval"

Scenario: Pending activities
  Given 2 pending activities exist
  And I am logged in as an admin
  Then I should see "2 Pending"
  When I visit the pending approval page
  Then I should be on the pending approval page
  And there should be 2 activities pending approval

Scenario: Approving pending activities
  Given 2 pending activities exist
  And I am logged in as an admin
  When I visit the pending approval page
  And I check an activity
  And I hit "Approve"
  Then I should be on the pending approval page
  And there should be 1 activity pending approval
  And I should see "Success! Activities approved."

Scenario: Denying pending activities
  Given 2 pending activities exist
  And I am logged in as an admin
  When I visit the pending approval page
  And I check an activity
  And I hit "Deny"
  Then I should be on the pending approval page
  And there should be 1 activity pending approval
  And I should see "Success! Activities denied."

Scenario: Clicking "Approve"/"Deny" with no activities checked
  Given 2 pending activities exist
  And I am logged in as an admin
  When I visit the pending approval page
  And I hit "Approve"
  Then I should be on the pending approval page
  And there should be 2 activities pending approval
  And I should not see "Success!"
