# [Healthy EFF](https://healthy-eff-169.herokuapp.com)
[![Code Climate](https://codeclimate.com/github/ashleywillard/healthy-eff/badges/gpa.svg)](https://codeclimate.com/github/ashleywillard/healthy-eff)
[![Test Coverage](https://codeclimate.com/github/ashleywillard/healthy-eff/badges/coverage.svg)](https://codeclimate.com/github/ashleywillard/healthy-eff)
[![Build Status](https://travis-ci.org/ashleywillard/healthy-eff.svg?branch=master)](https://travis-ci.org/ashleywillard/healthy-eff)

## Overview
Reporting system for employees to record healthy activities daily, so
management can track and reward employees monthly for a healthy lifestyle.

#### Dependencies:
* Ruby **1.9.3**
* Rails **3.2.16**

#### Gems:
All the gems used in this project are listed in the Gemfile, but notable ones
include the following:

    gem 'devise' # Sign-in and user functionality
    gem 'devise_invitable', '~> 1.3.4' # Mailing functionality
    gem "figaro" # Secret key handler
    gem 'rspec-rails', '~> 3.0' # Unit testing
    gem 'cucumber-rails' # Integration testing
    gem 'poltergeist' # Allows tests to run PhantomJS
    gem 'wkhtmltopdf-binary' # Creation of PDFs
    gem 'pdfkit' # Creation of PDFs
    gem 'simple_captcha', :git => 'git://github.com/galetahub/simple-captcha.git' # Generates captcha
    gem 'twitter-bootstrap-rails' # CSS styling
    gem 'fullcalendar-rails' # Calendar view
    gem 'bootstrap-datepicker-rails', '~> 1.4.0' # Date selection pops up a nice calendar
    gem 'bootstrap-glyphicons' # Provides icons through app

Credits to [Glyphicons](http://glyphicons.com/) for the icons used throughout the application.

## Set-up and Deployment

### To run on your local machine

Fork this repository to your own GitHub account.
Run the following command to clone to your local machine. It should look something like this:

    git clone https://github.com/<your username here>/healthy-eff

Now run the setup script:

    ./bin/setup

Remember to [configure the mailing system](#mailing-system) to invite new users.

Optionally, you can also [modify the initial database](#optional-modify-your-initial-database)
or [manually generate secret keys](#optional-generating-secret-keys) for authentication;
however, by default, this is automatically done through the script.

#### Mailing System

We'll need to set up a mailing system to invite new users to the application. You'll need to provide the following:

1. An email address
2. Password for the email
3. The host URL when you deploy on your own server

Open all three files in `config/environments/`. They all have somewhere near the top something that looks like this:

    config.action_mailer.default_url_options = { :host => 'localhost:3000' } # You'll change this for production.rb
    config.action_mailer.delivery_method = :smtp # May change this, but smtp usually the basic protocol
    config.action_mailer.perform_deliveries = true

    config.action_mailer.smtp_settings = {
        :enable_starttls_auto => true,
        :address => "smtp.gmail.com", # Depends on email service
        :port => 587,
        :domain => "gmail.com", # Depends on email service
        :authentication => :login,
        :user_name => "EMAILER", # Change this: Specify email account (everything before the @)
        :password => "PASSWORD" # Change this: Specify email account password
    }

You can specify which email to use depending on the environment (`development`, `test`, `production`). You can use the same email for all three, make each one different, or any other combination you see fit. Running the machine locally (covered in this section) will use the settings provided in `development.rb`; running our tests will use `test.rb`, and running the application on a deployed web server will use `production.rb`.

Check out the current setup on these files for a concrete example. The current email is just a random email we've made for the sole purpose of sending emails, which you can use if you would like.

#### (Optional) Modify your initial database

We've already added most of the employees, but feel free to change `db/seeds.rb`
to configure the starting database of the application.
If you want to add a new person (admin or user) before deploying, follow the
examples on the `db/seeds.rb` file.

#### (Optional) Generating secret keys

Devise and our application make use of a few secret keys to properly perform
authentication. To do this manually, you can generate them and place them in a
configuration file on your local machine.

We've already set up [Figaro](https://github.com/laserlemon/figaro) and
`.gitignore` to exclude this file from future GitHub pushes and thus hide these
keys from the public.

By default, this is done through the setup script (`./bin/setup`) in the call to
`./bin/keys`, but if you'd like to manually generate your own secret keys, you
can comment out that line and use the following:

    .../healthy-eff$ rake secret
    e19fd9b63ab682ffa4f33677b8fb742423db788df4d256cbbb7c5...

Save the entire string somewhere; repeat this three more times to obtain
**4 strings in total**.

Format `config/application.yml` (create it if it doesn't exist yet) as follows:

    cookie_token: # First secret key
    devise_token: # Second secret key
    production:
        cookie_token: # Third secret key
        devise_token: # Fourth secret key

Save this file once you're done.

#### Final set-up

Start a server and enjoy!

    .../healthy-eff$ rails s

Visit `localhost:3000` on your favorite browser to see the application.

### To deploy onto a web server
Check out [Heroku](https://www.heroku.com/) for easy deployment (which is what we have been using).

Remember to change `config.action_mailer.default_url_options` in `config/environment/production.rb` so that the mailing system works for your web server.

## Interactions

#### User Interactions

##### Log In Screen:
* A user can sign in after receiving an email from an administrator.

![Diagram](http://i.imgur.com/NkxC1PY.png)

##### Passwords:

Passwords must fulfill the following requirements:

* Eight character minimum
* Must contain at least one upper case letter
* Must contain at least one lower case letter
* Must contain at least one special character
* Must contain at least one number

##### Log Healthy Activity home page:
* Upon logging in, the user will be brought to this page

![Diagram](http://i.imgur.com/XFf35lZ.png)

* In order to submit an activity:
    * 'Duration' must be recorded in minutes (minimum 60 min.)
    * 'Activity' may be left blank
    * The user must fill in the captcha

* Users can submit only once for each day.
* User can add as many activities as they wish.
  * If JavaScript is enabled: click 'Add Activity' in order to add another exercise
  * If JavaScript is disabled, you will only be able to add a single activity per page

##### Add Past Days:
* To add previous days, click 'Input Past Days' at the bottom of the Log Healthy Activity home page. This will redirect you to the Add Previous Days page
* Adding any activity on the Past Day input page will send a request to the administrator for approval.
* For each day you want to add, click the date input box. If JavaScript is enabled, an datepicker will appear. Select which day you wish to add, otherwise type in the specific date in `mm/dd/yyyy` format.
* Proceed to add activities in the same manner as inputting today's activities. If JavaScript is disabled, the user will not be able to add more than one day per form.

![Diagram](http://i.imgur.com/QmmprIm.png)

* A user may only input past days for the current month. However if the current date is on or before the 5th, a user may input past days for the previous month as well. All other dates, including the current day, which must be inputted on the today page, are considered out of range and will return an error.
* Again, users can submit only once per day.
    * If a pending request has been denied, then the user may resubmit for that day.

##### User Calendar Page:
* After inputting an activity, the user will be brought to the Calendar page.
* Every recorded activity will appear here with the activity name and duration, as well as the activity's status ('Approved', 'Rejected', or 'Pending'.
* The User Calendar Page displays the amount earned each month at the top right of the page.

![Diagram](http://i.imgur.com/5HxhmCM.png)

* If JavaScript is disabled, the user can still view their calendar, but only through the past two months. Otherwise, the user can navigate through the calendar to see all months for which they have submitted healthy activities.

##### Settings:
* Users can change their password and email address on the Settings page.
* Users can also change their Timezone Settings from this page.
    * Default Timezone is Pacific Time

![Diagram](http://i.imgur.com/HyryXpA.png)

##### User Interface versus Admin Interface:

* General user restrictions: A user cannot access the admin page or the Manage page.

#### Admin Interactions

##### Admin page:
* To navigate to the Admin page, select the Admin tab at the top left.

![Diagram](http://i.imgur.com/Hqcfqw0.png)

* To select a specific month, use the arrow tabs. Tables will only appear for months with employee data.
* To generate a printable audit form or monthly accounting form, first select employees (either individually or through the select all checkbox), then select the appropriate option.
  * Only employees who have submitted a healthy activity the month being viewed will be available for selection.
* To view a specific employee's calendar, click the calendar icon in the corresponding row.

##### Manage page:
* From this page, admin can edit employee information, and add or delete employees.

![Diagram](http://i.imgur.com/T6Z3WQQ.png)

* While the admin can change the reimbursement rate, the rate is limited to four digit characters in length (i.e., $1111 and $11.11 are both valid; 11111 is not)
* Admins cannot delete themselves, but can still delete other admins; a confirmation window will pop up when this action is taken.
* Admins can make any employee an admin.

##### Pending Page:
* On the pending page, the admin can approve or deny employees' past day inputs.

![Diagram](http://i.imgur.com/vQmbQyf.png)

## Notes for further development

#### Running our current test suites

You'll need to install Phantom JS on your machine.

For Macs (with [Homebrew](http://brew.sh)):

    .../healthy-eff$ brew install phantomjs

For Ubuntu users, follow instructions on this [blog post](http://mariehogebrandt.se/articles/installing-phantomjs-and-casperjs-on-ubuntu/) for easy setup.

After you have PhantomJS installed, you can run our test suites. We used [Cucumber](https://github.com/cucumber/cucumber-rails) and [RSpec](https://github.com/rspec/rspec-rails) to test our application throughout the development process.

    .../healthy-eff$ db:test:prepare; rake cucumber; rake spec

## Development Tools
* [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/1282358)
* [Travis CI](https://travis-ci.org/ashleywillard/healthy-eff)
* [Code Climate](https://codeclimate.com/github/ashleywillard/healthy-eff)

## License

Developed through UC Berkeley's CS 169, in partnership with EFF.

Copyright (c) 2015 Sarah Hernandez, Alex Ho, Michelle Lin, Corinne Schafle, Allan Tang, Ashley Willard. See LICENSE for details.
