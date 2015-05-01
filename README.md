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

#### Gems:
All the gems used on this project are listed in the Gemfile, but notable ones include:
```
gem 'devise' #Sign-in and user functionality
gem 'devise_invitable', '~> 1.3.4' #Mailing functionality
gem "figaro" #Secret key handler
gem 'rspec-rails', '~> 3.0' #Unit Testing
gem 'cucumber-rails' #Integration Testing
gem 'poltergeist' #Allows tests to run PhantomJS
gem 'wkhtmltopdf-binary' #Creation of PDF's
gem 'pdfkit' #Creation of PDF's
gem 'simple_captcha', :git => 'git://github.com/galetahub/simple-captcha.git' #Generates captcha
gem 'twitter-bootstrap-rails' #CSS styling
gem 'fullcalendar-rails' #Calendar view
gem 'bootstrap-datepicker-rails', '~> 1.4.0' #Date selection pops up a nice calendar
gem 'bootstrap-glyphicons' #Provides icons through app; 
```
Credits to [Glyphicons](http://glyphicons.com/) for the icons in the application

## Set-up and Deployment

### To run on your local machine

Be sure that rails and ruby are installed on your machine. You can check by running
```
ruby -v; rails -v
```
which should display the current ruby version and rails version if installed correctly

Fork this repository to your own Github account.
Run the following command on in your shell to clone it to your local machine. It should look something like this:
```
git clone https://github.com/<your username here>/healthy-eff
```

#### Generate secret keys

A couple secret keys must be generated for Devise and our app to perform authentication. It's best that you generate your own keys, put them in a file, and place that file on your own local machine. With [Figaro](https://github.com/laserlemon/figaro), these keys will be hidden from the public, including update pushes to Github, as long as the file is part of the .gitignore file. 

We've already setup Figaro and the .gitignore, so an easy and safe way to do this is to perform the following:

```
.../healthy-eff$ rake secret
e19fd9b63ab682ffa4f33677b8fb742423db788df4d256cbbb7c5... # save this whole string somewhere
# Repeat this 3 more times to get a total of 4 strings
```

Create a new blank file called application.yml and place it directly under the config folder. Format the file like so:
```
cookie_token: <insert first string here>
devise_token: <insert second string here>
production: 
  cookie_token: <insert third string here>
  devise_token: <insert fourth string here>
```
You can to choose to generate your own strings if you'd like. Save the file once you're done

#### Mailing System

We'll also need to set up a mailing system, which you'll need to provide
```
1. An email address 
2. Password for the email. 
3. The host URL when you deploy to your own website server
```

This is so that you can invite new users to the application. Open all three files in config/environments. They all have somewhere near the top something that looks like this:
```
  config.action_mailer.default_url_options = { :host => 'localhost:3000' } # You'll change this for production.rb
  config.action_mailer.delivery_method = :smtp #May change this, but smtp usually the basic protocol
  config.action_mailer.perform_deliveries = true

  config.action_mailer.smtp_settings = {
    :enable_starttls_auto => true,
    :address => "smtp.gmail.com", #Depending on what email service you're using, might change this
    :port => 587,
    :domain => "gmail.com", #Depending on what email service you're using, might change this
    :authentication => :login,
    :user_name => "169.healthyeff", #Change this: Specify email account
    :password => "northsidepotato" #Change this: Specify email account password
  }
```
You can specify which email to use depending on the environment (development, test, production). You can use the same email for all three, make each one different, or any other combination you see fit. Running the machine locally (which is what this section aims for) will use development.rb, running our tests will use test.rb, and running the application on a deployed web server will use production.rb. 

Check out the current setup on these files for a concrete example. The current email is just a random email we've made for the sole purpose of sending emails, which you can use if you want. 

#### Set up your initial database

We've already added most of the employees, but feel free to change db/seeds.rb to configure the starting database of the application. If you want to add a new person (admin or user) at the start of the application, just follow the examples on the seed.rb file.

#### Final set-up

Run the following to set up the gems we've used for this project. 
```
.../healthy-eff$ bundle install
```

Run the following to restart the database and add in the employees you specified in the db/seed.rb file. ***Note: this will wipe the current database and start from only the seeds. All previous workouts and transactions will be deleted. You'll probably only want to run this once for setup.***

```
.../healthy-eff$ rake db:reset
```

Start a server and enjoy! Visit localhost:3000 on your favorite browser to see application

``` 
.../healthy-eff$ rails s
```

### To deploy onto a web server
Check out [Heroku](https://www.heroku.com/) for easy deployment, which is what we have been using.

Remember to change config.action_mailer.default_url_options in the config/environment/production.rb so that the mailing system works for the URL your web server is using.

## Tools
* [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/1282358)
* [Travis CI](https://travis-ci.org/ashleywillard/healthy-eff)
* [Code Climate](https://codeclimate.com/github/ashleywillard/healthy-eff)

## Interactions

#### User Interactions

##### Log In Screen:
* After receiving an email from admin, user can sign in
* Passwords must fulfill password requirements, user's password must contain one upper case letter, one lower case letter, a special character, a number, and has to be at least eight characters long. 

![Diagram](http://i.imgur.com/NkxC1PY.png)

##### Log Healthy Activity Home Page:
* Upon logging in, the user will be brought to this page 
* User can add as many activities as they wish, however in order to submit, time exercising must be greater than or equal to 60 minutes. 
  * If JavaScript is not enabled, you will only be able to add a single activity per page 
  * If JavaScript is enabled: click Add Activity in order to add another exercise 
* All input for exercise must be recorded in minutes
* Activity may be left blank, but time must be filled in to submit
* In order to submit, User must fill in captcha
* Users can submit only once for each day

![Diagram](http://i.imgur.com/XFf35lZ.png)

##### Add Past Days:
* To add previous days, click Input Past Days at the bottom of the Log Healthy Activity Home Page, this will redirect you to the Add Previous Days Page
* Adding any activity on the Past Day input page will send a request to the administrator for approval.
* For each day you want to add, click the date input box, if JavaScript is enabled, an datepicker will appear, select what day you wish to add, otherwise type in the specific date in the format mm/dd/yyyy.
* Proceed to add activities in the same manner as inputting today's activities
* If JavaScript is not enabled, User will not be able to add multiple days on one form
* A user may only input past days for the current month. However if the current date is on or before the 5th, a user may input past days for the previous month as well. All other dates, including the current day, which must be inputted on the today page, are considered out of range and will return an error.
* Users can submit only once for each day, with the exception of the case where a pending request has been denied. Then the user may submit again for that day.

![Diagram](http://i.imgur.com/QmmprIm.png)

##### User Calendar Page:
* After inputting either today or past day's healthy activity, User will be brought to the Calendar page
  * User will see a standard calendar, for every day they worked out, they will see what they did and how long, as well as the status of that activity: either 'Approved', 'Rejected', or 'Pending'
* If JavaScript is not enabled User can still view their calendar, however this will only allow them to see the past two months. 
* With JavaScript enabled, User can navigate the calendar to see all months that they have submitted healthy activities for
* The User Calendar Page will also show the amount earned each month at the top right of the page

![Diagram](http://i.imgur.com/5HxhmCM.png)

##### Settings: 
* On the Settings page, users can change their password and email address

![Diagram](http://i.imgur.com/CenTdL8.png)

##### User Interface versus Admin Interface:

* General User restrictions: User cannot access the admin page or the manage page.

#### Admin Interactions

##### Admin Page:
* To navigate to the Admin Page, select the Admin tab at the top left of your browser. 
* To select a specific month, use the arrow tabs
  * Only months with employee data will appear 
* To generate the pdf audit sheet or the monthly accounting sheet, first select employees, then select either Print Audit Sheet or Print Selected
  * Admin can either select all employees, or individually select employees.  
  * Only employees who have submitted a healthy activity in the month being viewed will be available to be selected via checkbox
* To audit a specific employee's calendar, click the calendar image in the row that corresponds to that employee's name

![Diagram](http://i.imgur.com/Hqcfqw0.png)

##### Manage Page: 
* From this page, admin can edit employee information, such as adding new employees, editing current employee information, and deleting employees
* While Admin can change the reimbursement rate, it is limited to four numbers in length (not counting a period, so 1111 and 11.11 are both valid. 11111 is not)
* Admins cannot delete themselves, but can still delete other admins
* Admins can make any employee an admin
  * There is a confirmation window when you add or delete an admin

![Diagram](http://i.imgur.com/T6Z3WQQ.png)

##### Pending Page:
* On the pending page Admin can approve or deny employees' past day inputs. Admin will be presented with the date the employee wants to add as well as the reason for inputting the day late  

![Diagram](http://i.imgur.com/vQmbQyf.png)

## Notes for further development

#### Running our current test suites

You'll need to install Phantom JS on your machine. For Macs, it is easy as running:

```
.../healthy-eff$ brew install phantomjs
```

For Ubuntu users, credits to this [blog](http://mariehogebrandt.se/articles/installing-phantomjs-and-casperjs-on-ubuntu/) for easy setup

After you have PhantomJS installed, you can run our test suites. We used [cucumber](https://github.com/cucumber/cucumber-rails) and [rspec](https://github.com/rspec/rspec-rails) to test out our application
```
.../healthy-eff$ rake cucumber; rake spec
``` 

##License

Copyright (c) 2015 Sarah Hernandez, Ashley Willard, Michelle Lin, Corinne Schafle, Allan Tang, Alex Ho. See LICENSE for details.
