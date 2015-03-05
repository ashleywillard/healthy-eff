Feature: Log Healthy Activity

  As an employee
  So that I can get credit/money for exercise
  I want to log my healthy activity for the day

Scenario: Adding one exercise for 1 day
  Given I am logged in and at the home page,
  When I fill in activity textbox with activity
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on my profile page
  And I should see a confirmation message

Scenario: Adding multiple exercises for a single day
  Given I am logged in and at the home page,
  When I fill in multiple activity and activity durations
  And I write the captcha text in the textbox
  And I press “Submit”
  Then I should be on “my profile page”
  And I should see a confirmation flash message

Scenario: Entering wrong captcha
  Given I am logged in and at the home page, 
  When I fill in a wrong captcha
  And I press “Submit”
  Then I should be on the home page
  And I should see a error flash message