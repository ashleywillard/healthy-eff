# [Healthy EFF](https://healthy-eff-169.herokuapp.com)
[![Code Climate](https://codeclimate.com/github/ashleywillard/healthy-eff/badges/gpa.svg)](https://codeclimate.com/github/ashleywillard/healthy-eff)
[![Test Coverage](https://codeclimate.com/github/ashleywillard/healthy-eff/badges/coverage.svg)](https://codeclimate.com/github/ashleywillard/healthy-eff)

CS169, in partnership with EFF.

## Overview
Reporting system for employees to record healthy activities daily, so management can track and reward employees monthly for a healthy lifestyle.

##### Group Members:
Group 17: Alex Ho, Allan Tang, Ashley Willard, Corinne Schafle, Michelle Lin, Sarah Hernandez

##### Dependencies: 
Ruby **1.9.3**
Rails **3.2.16**

## Set-up and Deployment

#### To run on your local machine

Be sure that rails and ruby are installed on your machine. You can check by running
```
ruby -v; rails -v
```
which should return some version number.

Fork this repository to your own Github account and clone it to your local machine
```
git clone https://github.com/<your username here>/healthy-eff
```

A couple secret keys must be generated for Devise and our app to perform authentication. It's best that you generate your own keys, put them in a file, and place that file on your own local machine. With [Figaro](https://github.com/laserlemon/figaro), these keys will be hidden from the public, including update pushes to Github, as long as the file is part of the .gitignore file. 

We've already setup Figaro and the .gitignore, so an easy way to do this is to perform the following:

```
healthy-eff$ rake secret
e19fd9b63ab682ffa4f33677b8fb742423db788df4d256cbbb7c5... # save this whole string somewhere
# Repeat this 3 more times to get a total of 4 strings
```

Create a new blank file called application.yml and place it directly under the config folder . Format the file like so:
```
cookie_token: <insert first string here>
devise_token: <insert second string here>
production: 
  cookie_token: <insert third string here>
  devise_token: <insert fourth string here>
```
You can to choose to generate your own strings in your own way if you like. 
Save the file and run the following commands to set up the application and database
```
bundle install
rake db:reset
```
Start a server and enjoy!
``` 
rails s
```

#### To deploy onto a web server
Check out [Heroku](https://www.heroku.com/) for easy deployment!

## Tools
* [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/1282358)
* [Travis CI](https://travis-ci.org/ashleywillard/healthy-eff)
* [Code Climate](https://codeclimate.com/github/ashleywillard/healthy-eff)



## Interactions

#### User Interactions

##### Log In Screen:
* After receiving an email from admin, user can sign in
* Passwords must fufill password requirements, user's password must contain one upper case letter, one lower case letter, a special character, a number, and has to be at least eight characters long. 

![Diagram](http://i.imgur.com/NkxC1PY.png)

##### Log Healthy Activity Home Page:
* Upon logging in, the user will be brought to this page 
* User can add as many activities as like wish, however in order to submit, time exersizing must be greater than or equal to 60 minutes. 
  * If javaScript is not enabled, you will only be able to add a single activity per page 
  * If javaScript is enabled: click Add Activity in order to add another exersize 
* All input for exersize must be recorded in minutes
* Activity may be left blank, but time must be filled in to submit
* In order to submit, User must fill in captcha
* Users can submit only one Healthy Activity for the current day

![Diagram](http://i.imgur.com/FJvH28c.png)

##### Add Previous Days:
* To add previous days, click Input Past Days at the bottom of the Log Healty Activity Home Page, this will redirect you to the Add Previous Days Page
* For each day you want to add, click the date input box, if javaScript is enabled, an datepicker will appear, select what day you wish to add, otherwise type in the specific date.
* Proceed to add activites in the same manner as inputing today's activities
* If javaScript is not enabled, User will not be able to add multiple days on one form

##### User Calendar Page:
* After inputing either today or past day's healthy activity, User will be brought to the Calendar page
  * User will see a standard calendar, for every day they worked out, they will see what they did and how long, as well as the status of that activity: either 'Approved', 'Rejected', or 'Pending'
* If javaScript is not enabled User can still view their calendar, however this will only allow them to see the past two months. 
* With javaScript enabled, User can navigate the calendar to see all months that they have submitted healty activities for
* The User Calendar Page will also show the amount earned this month at the top right of the page

##### User Interface versus Admin Interface:

* General User restrictions: User cannot access the admin page or the manage page.



##### Administrator Restrictions

* Admin Page Restrictions: Only employees who have submitted a healthy activity in the month selected will be available to select via checkbox, 

* Manage Page Restrictions: Admin can only change the reimbursement rate by four numbers in length (not counting a period, so 1111 and 11.11 are both valid. 11111 is not). Admins cannot delete themselves, although other admins can delete other admins. 

##License



Copyright (c) 2015 Sarah Hernandez, Ashley Willard, Michelle Lin, Corinne Schafle, Allan Tang, Alex Ho. See LICENSE for details.
