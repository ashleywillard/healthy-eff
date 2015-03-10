class Day < ActiveRecord::Base
  attr_accessible :date, :total

  validate :valid_total
  
  def valid_total
  	if total < 60
  		errors.add(:total, "can't be less than 60 mins")
  	end
  end
end
