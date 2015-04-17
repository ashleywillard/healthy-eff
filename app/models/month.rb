class Month < ActiveRecord::Base
  attr_accessible :month, :num_of_days, :printed_form, :received_form, :user_id, :year
  has_many :days, :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :days, :allow_destroy => true

  # TO DO
  # Add accessor method to get models for all users corresponding to a specific month

  def self.get_month_model(user_id, month, year)
    month_model = self.where(user_id: user_id, month: month, year: year)
    return month_model == nil ? nil : month_model.first
  end

  def self.get_or_create_month_model(user_id, month, year)
    month_model = self.get_month_model(user_id, month, year)
    return month_model unless month_model == nil
    return self.create!({:user_id => user_id,
                   :month => month,
                   :year => year,
                   :printed_form => false,
                   :received_form => false,
                   :num_of_days => 0})
  end

  def self.get_inputted_dates(user_id, start_date, end_date)
    month1 = end_date.strftime("%m")
    month2 = start_date.strftime("%m")
    previously_inputted = self.get_dates_list(user_id, month1, end_date.strftime("%Y"))
    previously_inputted += self.get_dates_list(user_id, month2, start_date.strftime("%Y")) unless month1 == month2
    return previously_inputted
  end

  def self.get_dates_list(user_id, month, year)
    dates = []
    month_model = self.get_month_model(user_id, month, year)
    return dates if month_model == nil
    month_model.days.each do |day|
      dates += [day.date.strftime("%m/%d/%Y")]
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

  def self.get_users_earliest_month(user_id)
    months = self.where(user_id: user_id, year: Month.minimum(:year))
    return months == nil ? nil : months.where(month: months.minimum(:month)).first
  end

  def self.get_earliest_months
    months = self.where(year: Month.minimum(:year))
    return months.first == nil ? nil : months.where(month: months.minimum(:month))
  end

  def contains_date?(date)
  	self.days.each do |day|
    	return true if day.date.strftime("%m/%d/%Y") == date.strftime("%m/%d/%Y")
    end
    return false
  end

end
