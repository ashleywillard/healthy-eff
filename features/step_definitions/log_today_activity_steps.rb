Given /I am on the home page/ do
  visit '/today'
end

And /I am on the multiple day input page/ do
  visit '/multiple_days'
  assert page.current_path == multiple_days_path
end

And /I fill out "Date"/ do
  fill_in(@date, :with => '3/10/2015')
end

When /I click "Add day"/ do
  click_link "Add Day"
end

When /I fill in activity with:(.*)/ do |entry_list|
  entries = entry_list.split(',')
  puts entries
  entries.each do
    click_link('Add Activity')
  end

  name_ids = page.body.scan(/day_activities_attributes_.{0,20}_name/m)
  duration_ids = page.body.scan(/day_activities_attributes_.{0,20}_duration/m)
  
  puts name_ids
  puts duration_ids

  entries.zip(name_ids, duration_ids).each do |entry, name_id, dur_id|
    activity = entry.split(' ')
    puts page.body
    fill_in name_id, :with => activity.first
    fill_in dur_id,  :with => activity.last

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

