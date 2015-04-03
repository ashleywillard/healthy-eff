# encoding: UTF-8

# ====================== PATH DEFINITIONS ====================== #

Given (/^I (?:am on|visit|go to) (?:|the) (.*) (?:|page|view)/) do |view|
  if view == "home" or view == "today"
    visit_path = today_path
  elsif view == "sign in" or view == "log in"
    visit_path = new_user_session_path
  elsif view == "user settings"
    visit_path = edit_user_registration_path
  elsif view == "my profile"
    visit_path = profile_path
  elsif view == "multiple day input"
    visit_path = multiple_days_path
  elsif view == "manage employee"
    visit_path =  manage_path
  elsif view == "add employee"
    visit_path = new_user_invitation_path
  elsif view == "pending approval"
    visit_path = admin_pending_path
  elsif view == "admin list"
    visit_path = admin_list_path
  elsif view == "forgot password"
    visit_path = new_user_password_path
  elsif view == "any"
    pass
  end
  visit visit_path
end

# Given (/I am on the home page/) do
# #   visit '/today'
#   visit today_path
# end
# 
# Given (/I am on the sign in page/) do
# #   visit '/users/sign_in'
#   visit new_user_session_path
# end
# 
# Given (/I am on the user settings page/) do
# #   visit '/users/edit'
#   visit edit_user_registration_path
# end
# 
# Given (/I am on my profile page/) do
# #   visit '/profile'
#   visit profile_path
# end
# 
# And (/I am on the multiple day input page/) do
# #   visit '/multiple_days'
#   visit multiple_days_path
# end
# 
# # Manage employee page
# And (/I visit the manage employee page/) do
#   visit manage_path
# end
# 
# # Add employee page
# And (/I visit the add employee page/) do
#   visit new_user_invitation_path
# end
# 
# # Pending approval page
# And (/I visit the pending approval page/) do
#   visit admin_pending_path
# end
# 
# # Forgot password page
# And (/I am on the forgot password page/) do
#   visit new_user_password_path
# end
# 
# # Admin employee list page
# Given (/^I visit the admin list/) do
#   visit admin_list_path
# end
# 
# And (/I am on any page/) do
#   # Undefined for now 
# end

# ======================= PATH ASSERTIONS ====================== #
Then (/^I should be on (?:the|my) (.*) (?:page|view)/) do |view|
  if view == "home" or view == "today"
    expected_path = today_path
  elsif view == "sign in" or view == "log in"
    expected_path = new_user_session_path
  elsif view == "user settings"
    expected_path = edit_user_registration_path
  elsif view == "profile"
    expected_path = profile_path
  elsif view == "multiple day input"
    expected_path = multiple_days_path
  elsif view == "forgot password"
    expected_path = user_password_path
  elsif view == "add employee"
    expected_path = new_user_invitation_path
  elsif view == "manage employee"
    expected_path = manage_path
  elsif view == "pending approval"
    expected_path = admin_pending_path
  elsif view == "admin list"
    expected_path = admin_list_path
  end
  expect(page.current_path).to eq(expected_path)
#   assert page.current_path == expected_path
end

# Then (/I should be on the home|today page/) do
#   assert page.current_path == today_path
# end
# 
# Then (/I should be on the sign in page/) do
#   assert page.current_path == new_user_session_path
# end
# 
# Then (/I should be on the user settings page/) do
#   assert page.current_path == edit_user_registration_path
# end
# 
# Then (/I should be on my profile page/) do
#   assert page.current_path == profile_path
# end
# 
# Then (/I should be on the multiple day input page/) do
#   assert page.current_path == multiple_days_path
# end
# 
# Then (/I should be on the forgot password page/) do
#   assert page.current_path == user_password_path
# end
# 
# Then (/I should be on the add employee page/) do
#   assert page.current_path == new_user_invitation_path
# end
# 
# Then (/I should be on the manage employee page/) do
#   assert page.current_path == manage_path
# end
# 
# Then (/I should be on the pending approval page/) do
#   assert page.current_path == admin_pending_path
# end
# 
# Then (/^I should be on the admin list view|page/) do
#   assert page.current_path == admin_list_path
# end
