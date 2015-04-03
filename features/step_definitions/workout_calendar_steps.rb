# encoding: UTF-8

Given /the following months exist/ do |months_table|
  months_table.hashes.each do |month|
    Month.create!(month)
  end
end


Given /the following days exist/ do |day_table|
  day_table.hashes.each do |day|
    Day.create!(day)
  end
end

Given /the following activities exist/ do |activities_table|
  activities_table.hashes.each do |activity|
    Activity.create!(activity)
  end
end

And /I should see a calendar with my logged activities/ do
  while (!page.has_content?("April 2015"))
    page.execute_script("$('#calendar').fullCalendar('prev')")
  end
  page.should have_content("running: 35")
  page.should have_content("swimming: 25")
  page.should have_content("jogging: 60")
  page.should have_content("hiking: 60")
end

And /I should not see the previous months logged activities/ do
  page.should_not have_content("lifting: 60")
end


And /I should see a calendar with my last months logged activities/ do 
  page.should have_content("lifting: 60")
 end

When /^(?:|I )click on the calendar's (.*) arrow$/ do |link|
  case link
  when "next"
    page.execute_script("$('#calendar').fullCalendar('next')")
  when "previous"
    page.execute_script("$('#calendar').fullCalendar('prev')")
  end
end