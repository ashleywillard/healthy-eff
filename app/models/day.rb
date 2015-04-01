class Day < ActiveRecord::Base
  attr_accessible :date, :total_time, :reason, :approved, :user_id, :month_id, :denied
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
    # not currently working - will work on more later
    # unless :approved
    #   now = DateTime.now
    #   current_day = now.strftime("%d").to_i
    #   current_month = now.strftime("%m").to_i
    #   current_year = now.strftime("%Y").to_i
    #   day = date.strftime("%d").to_i
    #   month = date.strftime("%m").to_i
    #   year = date.strftime("%Y").to_i
    #   unless month == current_month && year == current_year && day < current_day
    #     unless current_day < 6
    #       errors.add(:date, "is invalid")
    #     else
    #       current_month = prev_month(current_month)
    #       current_year -= 1 if current_month == 12
    #       unless month == current_month && year == current_year
    #         errors.add(:date, "is invalid")
    #       end
    #     end
    #   end
    # end
  end

end
