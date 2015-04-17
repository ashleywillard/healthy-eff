# encoding: UTF-8

When(/^I provide my current password$/) do
  fill_in "user_current_password", :with => "Abcdef123?"
end

When(/^I type in a new password and confirm it$/) do
  fill_in "user_password", :with => "Iamabrandnewpotat0!"
  fill_in "user_password_confirmation", :with => "Iamabrandnewpotat0!"
  fill_in "user_current_password", :with => "Abcdef123?"
end

#Happy path stuff
When /I fill in the user_email field .*/ do
  fill_in "user_email", :with => "healthypotato@gmail.com"
end

When /I fill in the user_password field with my new password/ do
  fill_in "user_password", :with => "?Lolpotato169"
end

When /I fill in the user_password_confirmation field with my new password/ do
  fill_in "user_password_confirmation", :with => "?Lolpotato169"
end

When /I fill in the user_current_password field with my old password/ do
  fill_in "user_current_password", :with => "?Hotpotato169"
end

#Sad path stuff
When /I fill in the user_password_confirmation field with a DIFFERENT password/ do
  fill_in "user_password_confirmation", :with => "?Badpotato169"
end

And /I fill in the user_current_password field with a BAD old password/ do
  fill_in "user_current_password", :with => "?Badpotato169"
end
