class Activity < ActiveRecord::Base
  belongs_to :day
  belongs_to :user # through day?
  attr_accessible :name, :duration, :approved
end
