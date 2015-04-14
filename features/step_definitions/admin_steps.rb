# encoding: UTF-8

Then(/^I should see a table of employee names$/) do
  expect(page).to have_content("First Name")
  expect(page).to have_content("Last Name")
end

Then(/^there should be a column with the number of days each employee has worked out$/) do
  expect(page).to have_content("Days")
end

Then(/^I should not see the "(.*?)" link$/) do |link|
  expect(page).to_not have_link(link)
end

Then(/^there should be (\d+) (?:|activity|activities|day|days|) pending approval$/) do |num|
  expect(page).to have_content("Reason", :count => num.to_i + 1) # +1 for header
end

When(/^I check an activity|day$/) do
  find(:css, "#selected_[value='2']").set(true)
end

When(/^I hit "(.*)"$/) do |button|
  click_button(button)
end
