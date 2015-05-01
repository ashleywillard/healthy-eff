# encoding: UTF-8

Given /I am signed|logged in as an admin/ do
  visit '/users/sign_in'
  fill_in "user_email", :with => '169.healthyeff@gmail.com'
  fill_in "user_password", :with => '?Northsidepotato169'
  click_button "Sign In"
end

Given /I am signed|logged in as a non-admin/ do
  visit '/users/sign_in'
  fill_in "user_email", :with => 'healthypotato@gmail.com'
  fill_in "user_password", :with => '?Hotpotato169'
  click_button "Sign In"
end

When /I fill in my username and password/ do
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
  fill_in "user_password", :with => "?Northsidepotato169"
end

When /I fill in my username and the wrong password/ do
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
  fill_in "user_password", :with => "?Badpotato169"
end

Given(/^that I sign in as a new user$/) do
  User.create! :email => "blah@blah.com",
               :password => "Abcdef123?",
               :password_confirmation => "Abcdef123?",
               :password_changed => false
  visit '/users/sign_in'
  fill_in "user_email", :with => "blah@blah.com"
  fill_in "user_password", :with => "Abcdef123?"
  click_button "Sign In"
end

Given(/^that I sign in as a returning user$/) do
  User.create! :email => "blah@blah.com",
               :password => "Abcdef123?",
               :password_confirmation => "Abcdef123?",
               :password_changed => true
  visit '/users/sign_in'
  fill_in "user_email", :with => "blah@blah.com"
  fill_in "user_password", :with => "Abcdef123?"
  click_button "Sign In"
end

When /^I press “(.*)”$/ do |button|
  click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end
