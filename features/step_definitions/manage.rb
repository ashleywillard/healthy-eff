# encoding: UTF-8

Given /I am an admin/ do
  visit '/users/sign_in'
  fill_in "user_email", :with => '169.healthyeff@gmail.com'
  fill_in "user_password", :with => 'northsidepotato'
  click_button "Log in"
end

Given /I am a nonadmin/ do
  visit '/users/sign_in'
  fill_in "user_email", :with => 'healthypotato@gmail.com'
  fill_in "user_password", :with => 'hotpotato'
  click_button "Log in"
end

When(/^I follow “Add a new employee”$/) do
  click_link("Add a new employee")
end