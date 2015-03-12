class Activity < ActiveRecord::Base

  attr_accessible :name, :duration
  validates :name, :duration, presence: true
  validate :valid_duration

  belongs_to :day

  def valid_duration
  	if duration == nil || duration <= 0 || duration > 1440
  		errors.add(:duration, "can't be less than 0 or over 24 hours")
  	end
  end

end
