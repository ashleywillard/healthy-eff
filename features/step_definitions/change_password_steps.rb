# encoding: utf-8

Given (/I am on the user settings page/) do
  visit '/users/edit'
end

When /I fill in the user_email field .*/ do 
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
end

When /I fill in the user_password field .*/ do 
  fill_in "user_password", :with => "hotpotato"
end

When /I fill in the user_password_confirmation field .*/ do 
  fill_in "user_password_confirmation", :with => "hotpotato"
end

When /I fill in the user_current_password field .*/ do 
  fill_in "user_current_password", :with => "northsidepotato"
end

Then /I should be on the user settings page/ do
  assert page.current_path == new_user_session_path
end

# For some reason "And I press Update only matches with this one...not the one in login_steps.rb"
When (/^I press "(.*?)"$/) do |arg1|
  click_button(arg1)
end