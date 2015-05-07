And /I select timezone "(.*)"$/ do |timezone|
  page.select timezone, :from => 'user_current_timezone'
  click_button("Update Timezone")
end


