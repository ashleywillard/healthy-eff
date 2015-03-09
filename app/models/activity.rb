class Activity < ActiveRecord::Base
  attr_accessible :name, :duration, :approved
  belongs_to :user # through day?
  belongs_to :day
end
