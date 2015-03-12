class Activity < ActiveRecord::Base

  attr_accessible :name, :duration, :day_id
  validates :name, :duration, presence: true
  validate :valid_duration

  belongs_to :day

  def valid_duration
  	if duration == nil
      errors.add(:duration, "can't be blank")
    elsif duration <= 0 
  		errors.add(:duration, "can't be less than 0")
  	elsif duration > 1440
  		errors.add(:duration, "can't over 24 hours")
    end
  end

end
