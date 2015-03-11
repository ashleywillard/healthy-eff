# encoding: utf-8

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given /I am signed|logged in/ do
  visit '/users/sign_in'
  fill_in "user_email", :with => '169.healthyeff@gmail.com'
  fill_in "user_password", :with => 'northsidepotato'
  click_button "Log in"
end

Given /I am on the sign in page/ do
  visit '/users/sign_in'
end

When /I fill in my username and password/ do
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
  fill_in "user_password", :with => "northsidepotato"
end

When /I fill in my username and the wrong password/ do
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
  fill_in "user_password", :with => "badpotato"
end

Then /I should be on the sign in page/ do
  assert page.current_path == new_user_session_path
end

And /I am on any page/ do
  # Undefined for now 
end

When /^I press “(.*)”$/ do |button|
  click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end
