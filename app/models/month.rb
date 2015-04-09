class Month < ActiveRecord::Base
  attr_accessible :month, :num_of_days, :printed_form, :received_form, :user_id, :year
  has_many :days, :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :days, :allow_destroy => true

  def self.get_month_model(user_id, month, year)
  	month_model = Month.where(user_id: user_id, month: month, year: year)
    return month_model == nil ? nil : month_model.first
  end

  def self.get_or_create_month_model(user_id, month, year)
  	month_model = self.get_month_model(user_id, month, year)
  	return month_model unless month_model == nil
  	return Month.create({:user_id => user_id,
                   :month => month,
                   :year => year,
                   :printed_form => false,
                   :received_form => false,
                   :num_of_days => 0})
  end

end
