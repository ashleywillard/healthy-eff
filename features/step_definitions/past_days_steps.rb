# encoding: UTF-8

When /I fill in day and activity with:(.*)/ do |input|
  date_entries = input.split('|')
  if date_entries.count > 1
    (date_entries.count - 1).times do
      page.find('.day_link').trigger('click')
    end

    links = page.all("a.activity_link")
    date_entries.zip(links).each do |date_entry, link|
      (1..date_entry.split(',').length-1).each do
        link.click
      end
    end
  end

  date_ids = page.body.scan(/id="month_days_attributes_.{0,20}_date/m)
  name_ids = page.body.scan(/id="month_days_attributes_.{0,20}_activities_attributes_.{0,20}_name/m)
  duration_ids = page.body.scan(/id="month_days_attributes_.{0,20}_activities_attributes_.{0,20}_duration/m)

  date_entries.zip(date_ids) do |date_entry, date_id|

    act_durs=date_entry.split(',')
    date_field = act_durs.shift
    target_date = date_field
    if date_field == "Yesterday"
      target_date = Date.today.prev_day.strftime("%m/%d/%Y")
    elsif date_field == "2 Days Ago"
      target_date = Date.today.prev_day.prev_day.strftime("%m/%d/%Y")
    end
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

# And /I fill out "Activity"/ do
#   print page.html
#   click_link "a.#{"Add Activity"}"
#   fill_in("activity", :with => 'nothing')
#   fill_in("duration", :with => '60')
#   fill_in("Reason for inputting past days", :with => 'Im lazy, duh')
# end
And /I click Add Day/ do
  page.find('.day_link').trigger('click')
end

And /I click Remove Day/ do
  page.find('.remove_day').trigger('click')
end

And /I press Submit/ do
  page.find('.submit').trigger('click')
end

And /I fill out date/ do
  date_ids = page.body.scan(/id="month_days_attributes_.{0,20}_date/m)
  fill_in date_ids[0][4..-1], :with => Date.today.prev_day.strftime("%m/%d/%Y")
end

Given /My activity yesterday was denied/ do
  yesterday = Date.today.yesterday
  date_last_month = yesterday.ago(1.month).beginning_of_month
  m = Month.create_month_model(1, yesterday.month, yesterday.year)
  m.num_of_days = 1
  m.save!
  d = Day.create!({:date => yesterday,
              :approved => false,
              :denied => true,
              :total_time => 60,
              :reason => 'I forgot',
              :month_id => m.id})
  Activity.create!({:duration => 25,
                 :name => 'running',
                 :day_id => d.id})
  Activity.create!({:duration => 35,
                   :name => 'swimming',
                   :day_id => d.id})
end
# And /I should see a confirmation message for past days/ do
#     assert page.has_content?("approve")
# end
