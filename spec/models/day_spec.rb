require 'rails_helper'
include DateFormat

RSpec.describe Day, :type => :model do

  describe ".num_pending" do
    it "returns the total number of days pending approval" do
      today = get_today
      expect(Day.num_pending).to eq(0)
      pending = Day.create! :id => 1, :total_time => 60, :date => get_today.prev_day,
                            :approved => false, :denied => false, :reason => "r"
       expect(Day.num_pending).to eq(1)
      logged = Day.create! :id => 2, :total_time => 60, :date => get_today,
                           :approved => true, :denied => false, :reason => "r"
       expect(Day.num_pending).to eq(1)
    end
  end

  describe '#valid_total' do
    context 'Total time is less than 1 hour' do
      it 'Should raise error - total cant be less than 60 mins' do
        today = get_today
        day = Day.new({:date => today,
                    :approved => true,
                    :denied => false,
                    :total_time => 40,
                    :reason => "none"})
        assert !day.valid?
        expect(day.errors.full_messages[0]).to eq("Total can't be less than 60 mins")
      end
    end
    context 'Total time is greater than 1 day' do
      it 'should raise error - total cant be more than 24 hours' do
        today = get_today
        day = Day.new({:date => today,
                    :approved => true,
                    :denied => false,
                    :total_time => 1441,
                    :reason => "none"})
        assert !day.valid?
        expect(day.errors.full_messages[0]).to eq("Total can't be over 24 hours")
      end
    end
  end

  describe '#valid_date' do
    context 'Date is later than the 5th of the month and approved is false' do
      before :each do
        date = Time.strptime('01/07/2015', "%m/%d/%Y")
        Time.stub(:now).and_return(date)
      end
      context 'date in future' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => get_date("02/02/2015"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 02/02/2015 is not within allowed range. Note: You only have until the 5th of the month to input days for the previous month.")
        end
      end
      context 'date too far in past' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => get_date("12/31/2014"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 12/31/2014 is not within allowed range. Note: You only have until the 5th of the month to input days for the previous month.")
        end
      end
      context 'date is today' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => get_date("01/07/2015"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 01/07/2015 is not within allowed range. Note: You only have until the 5th of the month to input days for the previous month.")
        end
      end
      context 'date in range' do
        it 'should be valid and have no errors' do
          day = Day.new({:date => get_date("01/02/2015"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert day.valid?
          expect(day.errors.full_messages[0]).to eq(nil)
        end
      end
    end
    context 'Date is on or before the 5th of the month and approved is false' do
      before :each do
        date = Time.strptime('01/04/2015', "%m/%d/%Y")
        Time.stub(:now).and_return(date)
      end
      context 'date in future' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => get_date("02/02/2015"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 02/02/2015 is not within allowed range. Note: You only have until the 5th of the month to input days for the previous month.")
        end
      end
      context 'date too far in past' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => get_date("11/20/2014"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 11/20/2014 is not within allowed range. Note: You only have until the 5th of the month to input days for the previous month.")
        end
      end
      context 'date is today' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => get_date("01/04/2015"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 01/04/2015 is not within allowed range. Note: You only have until the 5th of the month to input days for the previous month.")
        end
      end
      context 'date in range' do
        it 'should be valid and have no errors' do
          day = Day.new({:date => get_date("12/30/2014"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert day.valid?
          expect(day.errors.full_messages[0]).to eq(nil)
        end
      end
    end
  end
end
