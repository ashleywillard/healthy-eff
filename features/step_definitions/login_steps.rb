Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

Given /I am signed in/ do
  visit '/users/sign_up'
  fill_in "email", :with => "169.healthyeff@gmail.com"
  fill_in "password", :with => "northsidepotato"
  fill_in "password", :with => "northsidepotato"
  click_button "Sign up"
end

And /I am on any page/ do
	# Undefined for now 
end





