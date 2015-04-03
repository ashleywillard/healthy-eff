Feature: Workout Calendar
  As a user
  So that I can see how many days I worked out this month
  I want to see a calendar with days marked when I worked out

Background: users in database
Given the following users exist:
  | email                       | password              | password_confirmation |    
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  | healthypotato@gmail.com     | hotpotato             | hotpotato             |
  Given the following months exist:
  | user_id  | month  | year | num_of_days | printed_form  | received_form |
  | 2        | 4      | 2015 | 3           | false         | false         |
  | 2        | 3      | 2015 | 1           | false         | false         |
  Given the following days exist: 
  | date        | approved | denied | total_time | reason            | month_id |   
  | 01/04/2015  | true     | false  | 60         | 'a legit reason1' | 1        |
  | 01/04/2015  | false    | false  | 60         | 'a legit reason2' | 1        |
  | 02/04/2015  | false    | true   | 60         | 'im a bad potato' | 1        |
  | 01/03/2015  | true     | false  | 60         | 'doesnt matter'   | 2        |
  Given the following activities exist:
  | duration | name     | day_id |    
  | 35       | running  | 1      |
  | 25       | swimming | 1      |
  | 60       | jogging  | 2      |
  | 60       | hiking   | 3      |
  | 60       | lifting  | 4      |
  Given I am logged in as a non-admin

@javascript
Scenario: Visiting my user profile page
  When I follow "Profile"
  Then I should be on my profile page
  And I should see a calendar with my logged activities
  And I should not see the previous months logged activities

@javascript
Scenario: Viewing previous months
  When I follow "Profile"
  Then I should be on my profile page
  When I click on the calendar's previous arrow
  Then I should see "March"
  And I should see a calendar with my last months logged activities

