class Activity < ActiveRecord::Base
  attr_accessible :name, :duration
  belongs_to :day
end
