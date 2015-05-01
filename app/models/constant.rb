class Constant < ActiveRecord::Base
  attr_accessible :curr_rate

  def self.get_constants
    return self.all.first
  end

  def self.get_work_rate
    return self.get_constants.curr_rate
  end

  def self.set_work_rate(rate)
    constant = self.get_constants
    constant.curr_rate = rate
    constant.save!
  end

end
