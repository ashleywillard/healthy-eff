# encoding: UTF-8

Given /I am signed|logged in as an admin/ do
  save_and_open_page
  visit '/users/sign_in'
  fill_in "user_email", :with => '169.healthyeff@gmail.com'
  fill_in "user_password", :with => '?Northsidepotato169'
  click_button "Log in"
end

Given /I am signed|logged in as a non-admin/ do
  visit '/users/sign_in'
  fill_in "user_email", :with => 'healthypotato@gmail.com'
  fill_in "user_password", :with => '?Hotpotato169'
  click_button "Log in"
end

When /I fill in my username and password/ do
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
  fill_in "user_password", :with => "?Northsidepotato169"
end

When /I fill in my username and the wrong password/ do
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
  fill_in "user_password", :with => "?Badpotato169"
end

When /^I press “(.*)”$/ do |button|
  click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end
