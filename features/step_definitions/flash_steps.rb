# encoding: UTF-8
include ErrorMessages

Then(/^"(.*)" should appear before "(.*)"$/) do |str1, str2|
  if not /#{str1}.*#{str2}.*/m.match(page.body)
    flunk str1 + " and " + str2 + " occur in the wrong order"
  end
end

Then(/^I should see "(.*)"$/) do |msg|
  expect(page).to have_content(msg)
end

Then(/^I should see activity "(.*)" and duration "(.*)"$/) do |activity, duration|
  expect(page).to have_content(activity_recorded(activity, duration, ""))
end

Then(/^I should see that the date is invalid$/) do
	expect(page).to have_content(INVALID_DATE)
end

Then(/^I should see that this date has already been inputted$/) do
  expect(page).to have_content(repeat_date "")
end

Then(/^I should see that "(.*)" "(.*)" has been deleted$/) do |first_name, last_name|
  expect(page).to have_content(user_deleted(first_name, last_name))
end

Then(/^I should see that I cannot access this page$/) do
  expect(page).to have_content(access_denied)
end

Then(/^I should see that no activities are pending approval$/) do
  expect(page).to have_content(NOTHING_PENDING)
end

Then(/^I should see that "(.*)" was successful$/) do |action|
  expect(page).to have_content(activities_action(action))
end

Then(/^I should not see "(.*")$/) do |msg|
  expect(page).to_not have_content(msg)
end

Then(/^I should be welcomed$/) do
  expect(page).to have_content(WELCOME)
end