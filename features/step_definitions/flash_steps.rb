# encoding: UTF-8

Then(/^I should see "(.*)"$/) do |msg|
  expect(page).to have_content(msg)
end

Then(/^I should not see "(.*")$/) do |msg|
  expect(page).to_not have_content(msg)
end
