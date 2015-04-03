# encoding: UTF-8

Given (/the following users exist/) do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given (/the following admins exist/) do |users_table|
  users_table.hashes.each do |user|
    user = User.create!(user)
    user.admin = true
    user.save
  end
end

Given (/(.*) (?:|pending|unapproved) (?:|activities|days) exist/) do |num|
  if num.casecmp("No") ; pass ; end
  u = User.create! :email => "blah@blah.com",
                   :password => "asdfjkl;asdfjkl;",
                   :password_confirmation => "asdfjkl;asdfjkl;"
  m = Month.create! :user_id => u.id
  num.to_i.times do
    Day.create! :date => Time.strptime("04/01/2015", "%m/%d/%Y"),
                :approved => false,
                :denied => false,
                :total_time => 60,
                :reason => 'Reason',
                :month_id => m.id
  end
end
