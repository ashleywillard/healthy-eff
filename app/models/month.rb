class Month < ActiveRecord::Base
  include DateFormat

  attr_accessible :month, :num_of_days, :printed_form, :received_form, :user_id, :year, :work_rate
  has_many :days, :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :days, :allow_destroy => true

  def self.get_user_months(month, year)
    Month.where(:month => month, :year => year)
  end

  def self.update_month_rates(timezone, rate)
    today = get_today(timezone)
    months = self.get_user_months(today.strftime("%m").to_i, today.strftime("%Y").to_i)
    months.each do |month|
      month.work_rate = rate
      month.save!
    end
  end

  def self.get_month_model(user_id, month, year)
    month_model = self.where(user_id: user_id, month: month, year: year)
    return month_model == nil ? nil : month_model.first
  end

  def self.get_or_create_month_model(user_id, month, year)
    month_model = self.get_month_model(user_id, month, year)
    return month_model unless month_model == nil
    return self.create_month_model(user_id, month, year)
  end

  def self.create_month_model(user_id, month, year)
    return self.create!({:user_id => user_id,
                   :month => month,
                   :year => year,
                   :printed_form => false,
                   :received_form => false,
                   :work_rate => Constant.get_work_rate,
                   :num_of_days => 0})
  end

  def self.get_inputted_dates(user_id, start_date, end_date)
    month1 = end_date.strftime("%m").to_i
    month2 = start_date.strftime("%m").to_i
    previously_inputted = self.get_dates_list(user_id, month1, end_date.strftime("%Y").to_i)
    previously_inputted += self.get_dates_list(user_id, month2, start_date.strftime("%Y").to_i) unless month1 == month2
    return previously_inputted.join(",")
  end

  def self.get_dates_list(user_id, month, year)
    dates = []
    month_model = self.get_month_model(user_id, month, year)
    return dates if month_model == nil
    month_model.days.each do |day|
      dates += [day.date.strftime("%m/%d/%Y")] unless day.denied == true
    end
    return dates
  end

  def self.get_approved_dates_list(user_id, month, year)
    dates = []
    month_model = self.get_month_model(user_id, month, year)
    return dates if month_model == nil
    month_model.days.each do |day|
      dates += [day.date.strftime("%m/%d/%Y")] if day.approved
    end
    return dates
  end

  def self.get_money_for_month(user_id, month, year)
    month_model = Month.get_month_model(user_id, month, year)
    amt_per_day = month_model != nil ? month_model.work_rate : Constant.get_work_rate
    approved_cnt = Month.get_approved_dates_list(user_id, month, year).length
    return "$" + (approved_cnt * amt_per_day).to_s
  end

  def self.get_users_earliest_month(user_id)
    months = self.where(user_id: user_id, year: Month.minimum(:year))
    return months == nil ? nil : months.where(month: months.minimum(:month)).first
  end

  def self.get_earliest_months
    months = self.where(year: Month.minimum(:year))
    return months.first == nil ? nil : months.where(month: months.minimum(:month))
  end

  def self.update_month(user_id, day)
    month_model = Month.get_or_create_month_model(user_id, day.date.strftime("%m").to_i, day.date.strftime("%Y").to_i)
    month_model.num_of_days += 1 if day.approved
    month_model.save!
    day.update_attributes(:month_id => month_model.id)
  end

  def contains_date?(date)
  	self.days.each do |day|
    	return true if day.date.strftime("%m/%d/%Y") == date.strftime("%m/%d/%Y") && day.denied == false
    end
    return false
  end

  def contains_approved_date?(date)
  	self.days.each do |day|
    	return true if day.date.strftime("%m/%d/%Y") == date.strftime("%m/%d/%Y") and day.approved
    end
    return false
  end

  def get_num_approved_days
    self.days.count('date', :distinct => true, :conditions => {:approved => true})
  end

  def get_num_pending_days
    self.days.count(:conditions => {:approved => false, :denied => false})
  end



end
