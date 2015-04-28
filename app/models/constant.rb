class Constant < ActiveRecord::Base
  attr_accessible :curr_rate

  def self.get_constants
    return self.all.first
  end

  def self.get_work_rate
    return self.get_constants.curr_rate
  end
end
