class Day < ActiveRecord::Base
  attr_accessible :date, :total_time, :reason, :approved, :user_id, :month_id
  validates :date, :reason, presence: true
  validate :valid_total, :valid_date
  belongs_to :user
  belongs_to :month
  has_many :activities, :dependent => :destroy
  accepts_nested_attributes_for :activities, :allow_destroy => true
  
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
      end_date = today.prev_day
      start_date = today.beginning_of_month
      if today.strftime("%d").to_i < 6
        start_date = today.ago(1.month).beginning_of_month
      end
      range = start_date..end_date
      unless range === date.to_date
        errors.add(:date, "is invalid #{date.to_date}")
      end
    end
  end

end
