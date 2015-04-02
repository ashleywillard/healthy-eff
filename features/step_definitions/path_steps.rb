# encoding: UTF-8

# ====================== PATH DEFINITIONS ====================== #

Given (/I am on the home page/) do
#   visit '/today'
  visit today_path
end

Given (/I am on the sign in page/) do
#   visit '/users/sign_in'
  visit new_user_session_path
end

Given (/I am on the user settings page/) do
#   visit '/users/edit'
  visit edit_user_registration_path
end

Given (/I am on my profile page/) do
#   visit '/profile'
  visit profile_path
end

And (/I am on the multiple day input page/) do
#   visit '/multiple_days'
  visit multiple_days_path
end

# Manage employee page
And (/I visit the manage employee page/) do
  visit manage_path
end

# Add employee page
And (/I visit the add employee page/) do
  visit new_user_invitation_path
end

# Pending approval page

# Forgot password page
And (/I am on the forgot password page/) do
  visit new_user_password_path
end


# Admin view page (employee list page?)

And (/I am on any page/) do
  # Undefined for now 
end

# ======================= PATH ASSERTIONS ====================== #

Then (/I should be on the home|today page/) do
  assert page.current_path == today_path
end

Then (/I should be on the sign in page/) do
  assert page.current_path == new_user_session_path
end

Then (/I should be on the user settings page/) do
  assert page.current_path == edit_user_registration_path
end

Then (/I should be on my profile page/) do
  assert page.current_path == profile_path
end

Then (/I should be on the multiple day input page/) do
  assert page.current_path == multiple_days_path
end

Then (/I should be on the forgot password page/) do
  assert page.current_path == user_password_path
end

Then (/I should be on the add employee page/) do
  assert page.current_path == new_user_invitation_path
end

Then (/I should be on the manage employee page/) do
  assert page.current_path == manage_path
end