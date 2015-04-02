# encoding: UTF-8

Then(/^I should see "(.*)"$/) do |msg|
  page.should have_content(msg)
end

Then(/^I should not see "(.*)"$/) do |msg|
  page.should have_no_content(msg)
end
