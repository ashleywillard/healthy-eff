Then(/^I should see "(.*)"$/) do |msg|
  page.should have_content(msg)
end
