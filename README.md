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


##### User Restrictions

* Log In Screen Restrictions: Password must fufill password requirements, user's password must contain one upper case letter, one lower case letter, a special character, a number, and has to be at least eight characters long. 

* Log Healthy Activity Home Page Restrictions: Activity may be left blank, however it should reflect a healthy activity, time exercised must be greater than 60 minutes, you may only submit one form per day (although you may submit multiple exercises on this form), User must fill out the captcha to submit.

* Input Past Days Restrictions: User must select a day, however they can add multiple when javaScript is enabled, Activity may be blank, time must again be greater than 60 minutes per each day entered, user must provide a reason for adding days late. 

* User Calendar Page Restrictions: User can view their calendar without javaScript, however this will only allow them to see the past two months.

*General User restrictions: User cannot access the admin page or the manage page.



##### Administrator Restrictions

* Admin Page Restrictions: Only employees who have submitted a healthy activity in the month selected will be available to select via checkbox, 

* Manage Page Restrictions: Admin can only change the reimbursement rate by four numbers in length (not counting a period, so 1111 and 11.11 are both valid. 11111 is not). Admins cannot delete themselves, although other admins can delete other admins. 

##License



Copyright (c) 2015 Sarah Hernandez, Ashley Willard, Michelle Lin, Corinne Schafle, Allan Tang, Alex Ho. See LICENSE for details.
