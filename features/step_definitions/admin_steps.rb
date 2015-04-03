# encoding: UTF-8

Then(/^I should see a table of employee names$/) do
  expect(page).to have_content("First Name")
  expect(page).to have_content("Last Name")
end

Then(/^I should see the number of days each employee worked out$/) do
  expect(page).to have_content("Days")
end

Then(/^I should not see the "(.*?)" link$/) do |link|
  expect(page).to_not have_link(link)
end

Then(/^there should be (\d+) activities pending approval$/) do |num|
  expect(page).to have_content("Reason", :count => num.to_i + 1) # +1 for header
end
