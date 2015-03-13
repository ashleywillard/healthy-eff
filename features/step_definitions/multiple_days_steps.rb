# encoding: utf-8


And /I am on the multiple day input page/ do
  visit '/multiple_days'
  assert page.current_path == multiple_days_path
end

When /I fill in day and activity with:(.*)/ do |input|
  date_entries = input.split('|')
  date_entries.each do
    click_link('Add Day')
  end
 
  links = page.all("a.activity_link")
  date_entries.zip(links).each do |date_entry, link|
    (1..date_entry.split(',').length-1).each do
      link.click
    end
  end
  

  date_ids = page.body.scan(/id="user_days_attributes_.{0,20}_date/m)
  name_ids = page.body.scan(/id="user_days_attributes_.{0,20}_activities_attributes_.{0,20}_name/m)
  duration_ids = page.body.scan(/id="user_days_attributes_.{0,20}_activities_attributes_.{0,20}_duration/m)

  date_entries.zip(date_ids) do |date_entry, date_id|
    
    act_durs=date_entry.split(',')
    target_date = act_durs.shift
    fill_in date_id[4..-1], :with => target_date
    
    act_durs.each do |obj|
      act_dur = obj.split(' ')
      fill_in name_ids.shift[4..-1], :with => act_dur[0]
      if act_dur[0] != act_dur[1]
        fill_in duration_ids.shift[4..-1], :with => act_dur[1]
      end
    end
  end
end  

Given /^I fill in reason with: "(.*?)"$/ do |msg|
  fill_in "days_reason", :with => msg
end

Then /I should be on the multiple day input page/ do
  assert page.current_path == multiple_days_path
end

# And /I fill out "Activity"/ do
#   print page.html
#   click_link "a.#{"Add Activity"}"
#   fill_in("activity", :with => 'nothing')
#   fill_in("duration", :with => '60')
#   fill_in("Reason for inputting multiple days", :with => 'Im lazy, duh')
# end
And /I click Add Day/ do
  click_link "Add Day"
end

And /I fill out date/ do
  date_ids = page.body.scan(/id="user_days_attributes_.{0,20}_date/m)
  fill_in date_ids[0][4..-1], :with => '3/10/2015'
end

# And /I should see a confirmation message for multiple days/ do
#     assert page.has_content?("approve")
# end