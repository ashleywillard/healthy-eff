# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create! :first_name => 'Will',
                    :last_name => 'Guo',
                    :email => '169.healthyeff@gmail.com',
                    :password => 'northsidepotato',
                    :password_confirmation => 'northsidepotato'

# Manually give admin privileges, since attr_protected
user.admin = true
user.save

#non-admin account
User.create! :first_name => 'Armando',
	         :last_name => 'Fox',
	         :email => 'healthypotato@gmail.com', 
             :password => 'hotpotato', 
             :password_confirmation => 'hotpotato'

#This creates an approved day for the non-admin account
Activity.create! :duration => 25, 
                 :name => 'running',
                 :day_id => 1
Activity.create! :duration => 35, 
                 :name => 'swimming',
                 :day_id => 1
Day.create! :date => Time.strptime("04/01/2015", "%m/%d/%Y"),
            :approved => true,
            :denied => false,
            :total_time => 60,
            :user_id => 2,
            :reason => 'A legit reason',
            :month_id => 1

#This creates a non-approved day for the non-admin account
Activity.create! :duration => 60, 
                 :name => 'running',
                 :day_id => 2
Day.create! :date => Time.strptime("04/02/2015", "%m/%d/%Y"),
            :approved => false,
            :denied => false,
            :total_time => 60,
            :user_id => 2,
            :reason => 'A legit reason',
            :month_id => 1

#This create a denied day for the non-admin account
Activity.create! :duration => 60, 
                 :name => 'hiking',
                 :day_id => 3
Day.create! :date => Time.strptime("04/03/2015", "%m/%d/%Y"),
            :approved => false,
            :denied => true,
            :total_time => 60,
            :user_id => 2,
            :reason => 'Because I just forgot -badpotato',
            :month_id => 1

#Month to hold all the days
Month.create! :user_id => 2,
              :month => 4,
              :year => 2015,
              :num_of_days => 3,
              :printed_form => false,
              :received_form => false
              



