class Activity < ActiveRecord::Base
  include ErrorMessages

  attr_accessible :name, :duration, :day_id
  validates :name, :duration, presence: true
  validate :valid_duration

  belongs_to :day

  def self.create_activity(activity, day)
    name = activity[:name].lstrip
    duration = activity[:duration]
    day.total_time += duration.to_i
    name = HEALTHY ACTIVITY if name == ""
    return Activity.new({:name => name, :duration => duration})
  end

  def valid_duration
    if duration == nil
      errors.add(:duration, NOT_BLANK)
    elsif duration <= 0
      errors.add(:duration, NOT_BELOW_ZERO)
    elsif duration > 1440
      errors.add(:duration, NOT_TOO_HIGH)
    end
  end

end
