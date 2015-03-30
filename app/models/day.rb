class Day < ActiveRecord::Base
  attr_accessible :date, :total_time, :reason, :approved, :user_id
  validates :date, :reason, presence: true
  validate :valid_total
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

end
