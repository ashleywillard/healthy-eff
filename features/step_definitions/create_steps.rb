# encoding: UTF-8
include DateFormat

Given (/^the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given(/^"(.*?)" exists as a user$/) do |name|
  u = User.create! :email => "blah@blah.com",
                   :password => "?1Asdfjkl;asdfjkl;",
                   :password_confirmation => "?1Asdfjkl;asdfjkl;"
  u.first_name = name.split[0] ; u.last_name = name.split[1] ; u.save
end

Given(/^"(.*?)" and "(.*?)" exist as users$/) do |name1, name2|
  u1 = User.create! :email => "blah@blah.com",
                    :password => "?1Asdfjkl;asdfjkl;",
                    :password_confirmation => "?1Asdfjkl;asdfjkl;"
  u1.first_name = name1.split[0] ; u1.last_name = name1.split[1] ; u1.save
  u2 = User.create! :email => "blah2@blah.com",
                    :password => "?1Asdfjkl;asdfjkl;",
                    :password_confirmation => "?1Asdfjkl;asdfjkl;"
  u2.first_name = name2.split[0] ; u2.last_name = name2.split[1] ; u2.save
end

Given (/^the following admins exist/) do |users_table|
  users_table.hashes.each do |user|
    user = User.create!(user)
    user.admin = true
    user.save
  end
end

Given (/^the following months exist/) do |months_table|
  months_table.hashes.each do |month|
    Month.create!(month)
  end
end

Given (/^the following days exist:/) do |day_table|
  day_table.hashes.each do |day|
    Day.create!(day)
  end
end

Given (/^the following activities exist:/) do |activities_table|
  activities_table.hashes.each do |activity|
    Activity.create!(activity)
  end
end

Given (/I have logged (.*) activities/) do |num|
  u = User.find_by_email("blah@blah.com")
  if u.nil?
    u = User.create! :email => "blah@blah.com",
                     :password => "?1Asdfjkl;asdfjkl;",
                     :password_confirmation => "?1Asdfjkl;asdfjkl;"
    u.first_name = "John" ; u.last_name = "Doe" ; u.save
  end
  m = Month.create! :user_id => u.id,
                    :month => Time.now.month,
                    :year => Time.now.year,
                    :num_of_days => num
  # num.to_i.times do
  for i in 0..num.to_i - 1
    Day.create! :date => Time.now - i.days,
                :approved => true,
                :denied => false,
                :total_time => 60,
                :reason => 'Reason',
                :month_id => m.id
  end
end

Given (/^(.*) (?:pending|unapproved) (?:|activities|days) exist/) do |num|
  if num.casecmp("No") ; end
  u = User.create! :email => "blah@blah.com",
                   :password => "?Ag0asdfasdf",
                   :password_confirmation => "?Ag0asdfasdf"
  m = Month.create! :user_id => u.id,
                    :num_of_days => 0
  num.to_i.times do
    Day.create! :date => Time.strptime("04/01/2015", "%m/%d/%Y"),
                :approved => false,
                :denied => false,
                :total_time => 60,
                :reason => 'Reason',
                :month_id => m.id
  end
end
