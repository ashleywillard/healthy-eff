# encoding: UTF-8

Then(/^I should see "(.*)"$/) do |msg|
  expect(page).to have_content(msg)
end

Then(/^I should see activity "(.*)" and duration "(.*)"$/) do |activity, duration|
  expect(page).to have_content(activity_recorded(activity, duration, ""))
end

Then /^I should see that the date is invalid$/ do
	expect(page).to have_content(invalid_date)
end

Then(/^I should see that this date has already been inputted$/) do
  expect(page).to have_content(repeat_date "")
end

Then(/^I should not see "(.*")$/) do |msg|
  expect(page).to_not have_content(msg)
end
