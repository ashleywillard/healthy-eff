# encoding: utf-8

Given /I am signed in/ do
  users_table.hashes.each do |user|
    User.create!(user)
  end
  visit '/users/sign_in'
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
  fill_in "user_password", :with => "northsidepotato"
  click_button "Log in"
end

And /I am on the multiple day input page/ do
  assert page.current_path == today_path
  click_link("I need to go back and input previous days")
end

When /I click "Add day"/ do
  click_link(add_day)
end
  

And /I fill out "Activity"/ do
  fill_in("activity", :with => 'nothing')
  fill_in("duration", :with => '60')
  fill_in("Reason for inputting multiple days", :with => 'Im lazy, duh')
end


And /I fill out "Date"/ do
  fill_in(@date, :with => '3/10/2015')
end


And /I write the captcha text in the textbox/ do
 activities_controller.any_instance.stubs(:check_simple_captcha).returns(true)
end


And /I press “Submit”/ do
  click_button("submit")
end 


Then /I should be on “my profile page”/ do
  assert page.current_path == profile_path
end


And /I should see a confirmation message for multiple days/ do
    assert page.has_content?("approve")
end