# encoding: UTF-8

# ====================== PATH DEFINITIONS ====================== #

Given (/^I am on any page/) do ; end

Given (/^I (?:am on|visit|go to) (?:|my|the) (.*) (?:|page|view)/) do |view|
  case view
    when "home", "today"
      visit_path = today_path
    when "sign in", "log in"
      visit_path = new_user_session_path
    when "user settings"
      visit_path = edit_user_registration_path
    when "calendar"
      visit_path = calendar_path
    when "past day input"
      visit_path = past_days_path
    when "manage employee"
      visit_path =  manage_path
    when "add employee"
      visit_path = new_user_invitation_path
    when "pending approval"
      visit_path = admin_pending_path
    when "admin list", "admin", "admin home"
      visit_path = admin_list_path
    when "forgot password"
      visit_path = new_user_password_path
    when "any"
  end
  fail if visit_path.nil?
  visit visit_path
end

# ======================= PATH ASSERTIONS ====================== #

Then (/^I should be on (?:the|my) (.*) (?:page|view)/) do |view|
  case view
    when "home", "today"
      expected_path = today_path
    when "sign in", "log in"
      expected_path = new_user_session_path
    when "user settings"
      expected_path = edit_user_registration_path
    when "calendar"
      expected_path = calendar_path
    when "past day input"
      expected_path = past_days_path
    when "forgot password"
      expected_path = user_password_path
    when "add employee"
      expected_path = new_user_invitation_path
    when "manage employee"
      expected_path = manage_path
    when "pending approval"
      expected_path = admin_pending_path
    when "admin list", "admin"
      expected_path = admin_list_path
  end
  expect(page.current_path).to eq(expected_path)
end
