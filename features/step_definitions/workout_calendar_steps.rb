# encoding: UTF-8

And (/^I set up the database with a few days$/) do
  today = Date.today
  date_last_month = today.ago(1.month).beginning_of_month
  m = Month.create_month_model(2, today.month, today.year)
  m.num_of_days = 1
  m.save!
  d = Day.create!({:date => today,
              :approved => true,
              :denied => false,
              :total_time => 60,
              :reason => 'A legit reason',
              :month_id => m.id})
  Activity.create!({:duration => 25,
                 :name => 'running',
                 :day_id => d.id})
  Activity.create!({:duration => 35,
                   :name => 'swimming',
                   :day_id => d.id})

  m2 = Month.create_month_model(2, date_last_month.month, date_last_month.year)
  m2.num_of_days = 1
  m2.save!
  d2 = Day.create!({:date => Time.strptime(date_last_month.strftime("%m/%d/%Y"), "%m/%d/%Y"),
              :approved => true,
              :denied => false,
              :total_time => 60,
              :reason => 'A legit reason',
              :month_id => m2.id})
  Activity.create!({:duration => 25,
                 :name => 'hiking',
                 :day_id => d2.id})
  Activity.create!({:duration => 35,
                   :name => 'biking',
                   :day_id => d2.id})
end

And /I should see a calendar with my logged activities/ do
  today = Date.today
  while (!page.has_content?("#{today.strftime("%B")} #{today.year}"))
    page.execute_script("$('#calendar').fullCalendar('prev')")
  end
  page.should have_content("running: 25")
  page.should have_content("swimming: 35")
end

And /I should not see the previous months logged activities/ do
  page.should_not have_content("hiking: 25")
  page.should_not have_content("biking: 35")
end

And /I should see a calendar with my last months logged activities/ do
  page.should have_content("hiking: 25")
  page.should have_content("biking: 35")
 end

When /^(?:|I )click on the calendar's (.*) arrow$/ do |link|
  case link
  when "next"
    page.execute_script("$('#calendar').fullCalendar('next')")
  when "previous"
    page.execute_script("$('#calendar').fullCalendar('prev')")
  end
end

Then /I should be able to click next/ do
  assert(!(page.body.include? "fc-button fc-button-next fc-state-default fc-corner-left fc-corner-right fc-state-disabled"))
end

Then /I should not be able to click next/ do
  assert(page.body.include? "fc-button fc-button-next fc-state-default fc-corner-left fc-corner-right fc-state-disabled")
end

Then /I should be able to click prev/ do
  assert(!(page.body.include? "fc-button fc-button-prev fc-state-default fc-corner-left fc-corner-right fc-state-disabled"))
end

Then /I should not be able to click prev/ do
  assert(page.body.include? "fc-button fc-button-prev fc-state-default fc-corner-left fc-corner-right fc-state-disabled")
end

And /I follow Calendar/ do
  page.find('.calendar_link').trigger('click')
end

