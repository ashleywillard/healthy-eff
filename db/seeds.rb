# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# ===== Admin account ===== #
user = User.create! :first_name => 'Will',
                    :last_name => 'Guo',
                    :email => '169.healthyeff@gmail.com',
                    :password => 'northsidepotato',
                    :password_confirmation => 'northsidepotato'
# Manually give admin privileges, since attr_protected
user.admin = true
user.save

# ===== Non-admin account ===== #
User.create! :first_name => 'Armando',
             :last_name => 'Fox',
             :email => 'healthypotato@gmail.com', 
             :password => 'hotpotato', 
             :password_confirmation => 'hotpotato'

# ===== Approved day, non-admin ===== #
Activity.create! :duration => 25, 
                 :name => 'running',
                 :day_id => 1
Activity.create! :duration => 35, 
                 :name => 'swimming',
                 :day_id => 1
d = Day.create! :date => Time.strptime("04/01/2015", "%m/%d/%Y"),
                :approved => true,
                :denied => false,
                :total_time => 60,
                :reason => 'A legit reason',
                :month_id => 1

# ===== Pending day, non-admin ===== #
Activity.create! :duration => 60, 
                 :name => 'running',
                 :day_id => 2
d = Day.create! :date => Time.strptime("04/02/2015", "%m/%d/%Y"),
                :approved => false,
                :denied => false,
                :total_time => 60,
                :reason => 'A legit reason',
                :month_id => 1

# ===== Denied day, non-admin ===== #
Activity.create! :duration => 60, 
                 :name => 'hiking',
                 :day_id => 3
d = Day.create! :date => Time.strptime("04/03/2015", "%m/%d/%Y"),
                :approved => false,
                :denied => true,
                :total_time => 60,
                :reason => 'Because I just forgot -badpotato',
                :month_id => 1

#Month to hold all the days
Month.create! :user_id => 2,
              :month => 4,
              :year => 2015,
              :num_of_days => 3,
              :printed_form => false,
              :received_form => false

# ===== Approved day, non-admin ===== #
Activity.create! :duration => 60, 
                 :name => 'swimming',
                 :day_id => 4

d = Day.create! :date => Time.strptime("03/31/2015", "%m/%d/%Y"),
                :approved => true,
                :denied => false,
                :total_time => 60,
                :reason => 'A legit reason',
                :month_id => 2

#Month to hold above day
Month.create! :user_id => 2,
              :month => 3,
              :year => 2015,
              :num_of_days => 1,
              :printed_form => true,
              :received_form => false