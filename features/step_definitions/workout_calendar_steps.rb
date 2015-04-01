# encoding: UTF-8

Given /the following months exist/ do |months_table|
  months_table.hashes.each do |month|
    Month.create!(month)
  end
end
