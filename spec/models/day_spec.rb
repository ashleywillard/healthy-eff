require 'rails_helper'

RSpec.describe Day, :type => :model do

  describe ".num_pending" do
    it "returns the total number of days pending approval" do
      expect(Day.num_pending).to eq(0)
      pending = Day.create! :id => 1, :total_time => 60, :date => Date.today,
                            :approved => false, :denied => false, :reason => "r"
       expect(Day.num_pending).to eq(1)
      logged = Day.create! :id => 2, :total_time => 60, :date => Date.today,
                           :approved => true, :denied => false, :reason => "r"
       expect(Day.num_pending).to eq(1)
    end
  end

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
  	context 'Date is on or before the 5th of the month' do
      it '' do
        Date.stub!(:today).and_return(Date.new(2015, 04, 04))
        day = Day.new({:date => "02/02/2015",
                    :approved => false,
                    :denied => false,
                    :total_time => 60,
                    :reason => "Vacation"})
        assert !day.valid?
        expect(day.errors.full_messages[0]).to eq("02/04/2015 is not within allowed range")
      end
    end
  	# case date is april 5 -  can input april 1 can input march 31 cannot input feb 28
  end
end
