# encoding: UTF-8

When(/^I follow “New employee”$/) do
  page.find('.add_new_employee').click
end

When (/I fill in email with "(.*)"/) do |email|
  fill_in "user_email", :with => email
end

When (/I fill in first name with "(.*)"/) do |name|
  fill_in "user_first_name", :with => name
end

When (/I fill in last name with "(.*)"/) do |name|
  fill_in "user_last_name", :with => name
end
