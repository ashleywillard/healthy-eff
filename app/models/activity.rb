class Activity < ActiveRecord::Base
  include ErrorMessages

  attr_accessible :name, :duration, :day_id
  validates :name, :duration, presence: true
  validate :valid_duration

  belongs_to :day

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
