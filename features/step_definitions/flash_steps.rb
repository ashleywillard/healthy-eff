# encoding: UTF-8

Then(/^I should see "(.*)"$/) do |msg|
  expect(page).to have_content(msg)
end
