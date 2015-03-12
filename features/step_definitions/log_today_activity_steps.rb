Given /I am on the home page/ do
  visit '/today'
end

When /I fill in activity with:(.*)/ do |entry_list|
  temp = entry_list.split(',')
  temp.each do |entry|
    activity = entry.split(' ')
    
    fill_in "activity_name", :with => activity[0]
    fill_in "activity_duration", :with => activity[1]
  end
end

When /I write the captcha text in the textbox/ do
  #activities_controller.any_instance.should_receive(:check_simple_captcha).and_return(true)
end

Then /I should be on my profile page/ do
  assert page.current_path == profile_path
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end