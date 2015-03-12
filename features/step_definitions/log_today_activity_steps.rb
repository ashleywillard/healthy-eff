Given /I am on the home page/ do
  visit '/today'
end

Given /I am logged in/ do
  visit '/users/sign_in'
  fill_in "user_email", :with => "169.healthyeff@gmail.com"
  fill_in "user_password", :with => "northsidepotato"
  click_button "Log in"
end

When /I fill in activity with:(.*)/ do |entry_list|
  temp = entry_list.split(' ')
  temp.each do |entry|
    activity = entry.split(',')
    
    fill_in "movie_title", :with => "northsidepotato"
    #page.find("#movie[title]")

    #set_hidden_field 'activity_name', :to => activity[0]
    #set_hidden_field 'activity_duration', :to => activity[1]
  end
end

When /I write the captcha text in the textbox/ do
  activities_controller.any_instance.stubs(:check_simple_captcha).returns(true)
end


