class Day < ActiveRecord::Base
  attr_accessible :date, :total_time, :reason, :approved, :user_id
  validates :date, :reason, presence: true
  validate :valid_total, :valid_date
  belongs_to :user
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
    unless :approved
      #start = beginning of this month
      #end = day before today
      # if day before 5th of month
        #start = beginning of last month
      #end
      #range = start..end
      # unless range === :date
        #errors.add(you suck)
    end
  end

end
