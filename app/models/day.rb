class Day < ActiveRecord::Base
  attr_accessible :date, :total_time, :reason, :approved, :month_id, :denied
  validates :date, :reason, presence: true
  validate :valid_total, :valid_date
  belongs_to :month
  has_many :activities, :dependent => :destroy
  accepts_nested_attributes_for :activities, :allow_destroy => true

  # Returns the total number of activity-days pending approval
  def self.num_pending
    Day.count(:conditions => {:approved => false, :denied => false})
  end

  def valid_total
    if total_time < 60
      errors.add(:total, "can't be less than 60 mins")
    elsif total_time > 1440
      errors.add(:total, "can't be more than 24 hours")
    end
  end

  def valid_date
    unless approved
      today = Date.today
      start_date = today.beginning_of_month
      start_date =  today.ago(1.month).beginning_of_month if today.strftime("%d").to_i < 6 
      end_date = today.prev_day
      unless ((start_date.to_date)..(end_date.to_date)) === (date.to_date) #check to see if date is in range
        errors.add(:date, "#{date.strftime("%m/%d/%Y")} is not within allowed range")
      end
    end
  end

  def user ; self.month.user ; end

end
