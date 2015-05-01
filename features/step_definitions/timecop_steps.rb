Given(/^the date is (.*)\-(.*)\-(.*)$/) do |month, day, year|
  Timecop.freeze(Date.new(year.to_i, month.to_i, day.to_i))
end
