class Month < ActiveRecord::Base
  attr_accessible :month, :num_of_days, :printed_form, :received_form, :user_id, :year
  has_many :days, :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :days, :allow_destroy => true
end
