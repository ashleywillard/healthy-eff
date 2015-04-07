# encoding: UTF-8

When(/^I fill in "(.*?)" into the email field$/) do |email|
  fill_in "user_email", :with => email
end
