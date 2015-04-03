# encoding: UTF-8

Then(/^I should see a table of employee names$/) do
  expect(page).to have_content("First Name")
  expect(page).to have_content("Last Name")
end

Then(/^I should see the number of days each employee worked out$/) do
  pending # express the regexp above with the code you wish you had
end