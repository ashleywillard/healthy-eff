Given (/I am on the user settings page/) do
  visit '/users/edit'
end

#Happy path stuff
When /I fill in the user_email field .*/ do 
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
end

When /I fill in the user_password field with my new password/ do 
  fill_in "user_password", :with => "hotpotato"
end

When /I fill in the user_password_confirmation field with my new password/ do 
  fill_in "user_password_confirmation", :with => "hotpotato"
end

When /I fill in the user_current_password field with my old password/ do 
  fill_in "user_current_password", :with => "northsidepotato"
end

#Sad path stuff
When /I fill in the user_password_confirmation field with a DIFFERENT password/ do
  fill_in "user_password_confirmation", :with => "badpotato"
end

And /I fill in the user_current_password field with a BAD old password/ do
  fill_in "user_current_password", :with => "badpotato"
end

#Path routes
Then /I should be on the user settings page/ do
  assert page.current_path == edit_user_registration_path
end

Then /I should be on the today page/ do
  assert page.current_path == today_path
end
