Given /I am on the home page/ do
  visit '/today'
end

When /I fill in activity with:(.*)/ do |entry_list|
  entries = entry_list.split(',')
  entries.each do
    click_link('Add Activity')
  end

  name_ids = page.body.scan(/id="day_activities_attributes_.{0,20}_name/m)
  duration_ids = page.body.scan(/id="day_activities_attributes_.{0,20}_duration/m)

  entries.zip(name_ids, duration_ids).each do |entry, name_id, dur_id|
    activity = entry.split(' ')
    fill_in name_id[4..-1], :with => activity.first
    if activity.first != activity.last
      fill_in dur_id[4..-1],  :with => activity.last
    end

  end
end

When /I write the captcha text in the textbox/ do
  fill_in "captcha", :with => "abc"
  #activities_controller.any_instance.should_receive(:check_simple_captcha).and_return(true)
end

Then /I should be on the home page/ do
  assert page.current_path == today_path
end

Then /I should be on my profile page/ do
  assert page.current_path == profile_path
end

# Repeat of what is already in flash_steps.rb - allan
# Then /^(?:|I )should see "([^"]*)"$/ do |text|
#   if page.respond_to? :should
#     page.should have_content(text)
#   else
#     assert page.has_content?(text)
#   end
# end