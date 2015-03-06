class Day < ActiveRecord::Base
  belongs_to :user
  has_many :activities
  attr_accessible :date, :total_time
end
