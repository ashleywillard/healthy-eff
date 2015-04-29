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

And(/^I navigate to the next month$/) do
  visit admin_list_path(:navigate => "Next")
end

And(/^I navigate to the previous month$/) do
  visit admin_list_path(:navigate => "Previous")
end

When(/^I fill in rate with "(.*?)"$/) do |rate|
  fill_in 'rate_input', :with => rate
end

Then (/^the current rate should be "(.*?)"$/) do |rate|
  expect(find_field("rate_input").value).to have_content(rate)
end

And (/^I update the rate to be "(.*?)"$/) do |rate|
  step "I visit the manage employee page"
  step "I fill in rate with \"15\""
  step "I press \“Update\”"
  step "the current rate should be \"15\""
end 