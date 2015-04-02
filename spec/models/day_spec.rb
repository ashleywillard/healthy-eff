require 'rails_helper'

RSpec.describe Day, :type => :model do
  describe '#valid_total' do
    context 'Total time is less than 1 hour' do
      it 'Should raise error - total cant be less than 60 mins' #do
      #end
    end
    context 'Total time is greater than 1 day' do
      it 'should raise error - total cant be more than 24 hours' #do
      #end
    end
  end

  describe '#valid_date' do
    before :each do
      #something
    end
  	context 'Date is later than the 5th of the month' do
  	# case date is april 6 - can input april 1 cannot input march 31 cannot input april 6
  	end
  	context 'Date is before the 5th of the month' do
  	# case date is april 5 -  can input april 1 can input march 31 cannot input feb 28
	end
  end
end
