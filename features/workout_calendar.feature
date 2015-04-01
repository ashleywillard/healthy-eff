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
  | user_id  | month  | year | num_of_days | printed_form  | received_from |
  | 2        | 4      | 2015 | 3           | false         | false         |
  Given the following days exist: 
  | date | approved | denied | total_time | user_id | reason | month_id |   
  

  Given the following activities exist:
  | email                       | password              | password_confirmation |    
  | 169.healthyeff@gmail.com    | northsidepotato       | northsidepotato       |
  | healthypotato@gmail.com     | hotpotato             | hotpotato             |
  Given that I am logged in as non-admin



Scenario: Visiting my user profile page
  Given that I am logged in as non-admin
  When I follow "profile"
  Then I should be on my profile page
  And I should see a calendar with my logged activities

Scenario: Viewing previous months
  When I click on the name of the month in the calendar
  Then I should see options for previous months
  And when I click on a previous month
  And I press “Refresh”
  Then I should see a list of employee names for that month