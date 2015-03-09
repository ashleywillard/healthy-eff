Given /the following users exist/ do |users_table|
	users_table.hashes.each do |user|
		User.create!(user)
	end
end

Given /I am signed in/

end

