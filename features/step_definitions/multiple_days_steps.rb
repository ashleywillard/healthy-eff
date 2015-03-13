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

  add_activity_ids = page.body.scan(//m) #STILL FILL IN 

  date_entries.zip(add_activity_ids).each do |date_entry, add_act_link|
    (1..date_entry.split(',').length-1).each do
      click_link(add_act_link)
    end
  end

  date_ids = page.body.scan(/id="user_days_attributes_.{0,20}_date/m)
  name_ids = page.body.scan(/id="user_days_attributes_.{0,20}_activities_attributes_.{0,20}_name/m)
  duration_ids = page.body.scan(/id="user_days_attributes_.{0,20}_activities_attributes_.{0,20}_duration/m)
  exercise_name = Array.new
  duration_name = Array.new

  date_entries.zip(date_ids) do |date_entry, date_id|
    
    act_durs=date_entry.split(',')
    target_date = act_durs.shift
    fill_in date_id[4..-1], :with => date_id
    
    act_durs.each do |act_dur|
      fill_in name_ids.shift[4..-1], :with => act_dur.first
      if act_dur.first != act_dur.last
        fill_in duration_ids.shift[4..-1], :with => act_dur.last
      end
    end
  end

  
    
  end
end  

And /I fill out "Activity"/ do
  print page.html
  click_link "a.#{"Add Activity"}"
  fill_in("activity", :with => 'nothing')
  fill_in("duration", :with => '60')
  fill_in("Reason for inputting multiple days", :with => 'Im lazy, duh')
end


And /I fill out "Date"/ do
  fill_in(@date, :with => '3/10/2015')
end

And /I should see a confirmation message for multiple days/ do
    assert page.has_content?("approve")
end