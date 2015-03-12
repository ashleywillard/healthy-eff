# encoding: utf-8


And /I am on the multiple day input page/ do
  visit '/multiple_days'
  assert page.current_path == multiple_days_path
end

When /I click "Add day"/ do
  click_link "Add Day"
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