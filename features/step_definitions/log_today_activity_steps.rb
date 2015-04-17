# encoding: UTF-8

And /I fill out "Date"/ do
  fill_in(@date, :with => '3/10/2015')
end

When /I fill in activity with:(.*)/ do |entry_list|
  entries = entry_list.split(',')
  (entries.count - 1).times do
    page.find('.activity_link').trigger('click')
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

Then(/^the activity field should contain "(.*)"$/) do |activity|
  name_ids = page.body.scan(/day_activities_attributes_.{0,20}_name/m)
  the_id = name_ids[0]
  value = page.find(:xpath, "//input[@id='#{the_id}']").value
  assert_equal(value, activity)
end

# Then /^(?:|I )should see "([^"]*)"$/ do |text|
#   if page.respond_to? :should
#     page.should have_content(text)
#   else
#     assert page.has_content?(text)
#   end
# end
