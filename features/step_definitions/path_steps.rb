# encoding: UTF-8

# ====================== PATH DEFINITIONS ====================== #

Given (/I am on the home page/) do
  visit '/today'
end

Given (/I am on the sign in page/) do
  visit '/users/sign_in'
end

Given (/I am on the user settings page/) do
  visit '/users/edit'
end

Given (/I am on my profile page/) do
  visit '/profile'
end

And (/I am on the multiple day input page/) do
  visit '/multiple_days'
  assert page.current_path == multiple_days_path
end

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
