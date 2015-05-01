After('@timecop') do
  Timecop.return
end

Given(/^the date is (\d+)\-(\d+)\-(\d+)$/) do |month, day, year|
  Timecop.freeze(Date.new(year.to_i, month.to_i, day.to_i))
end

Given(/^I travel to (\d+)\-(\d+)\-(\d+)$/) do |month, day, year|
  Timecop.travel(Date.new(year.to_i, month.to_i, day.to_i))
end
