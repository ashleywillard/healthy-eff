class Day < ActiveRecord::Base
  attr_accessible :date, :total_time
  validate :valid_total
  belongs_to :user
  has_many :activites, :dependent => :destroy
  accepts_nested_attributes_for :activites, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  def valid_total
  	if total < 60
  		errors.add(:total, "can't be less than 60 mins")
  	elsif total > 1440
  		errors.add(:total, "can't be more than 24 hours")
  	end
  end
end
