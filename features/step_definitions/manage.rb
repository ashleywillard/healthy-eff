# encoding: UTF-8

When(/^I follow “Add a new employee”$/) do
  click_link("Add a new employee")
end

When (/I fill in email with "(.*)"/) do |email|
  fill_in "user_email", :with => email
end
