class Activity < ActiveRecord::Base
  attr_accessible :name, :duration, :approved
  belongs_to :user
  belongs_to :day
end
