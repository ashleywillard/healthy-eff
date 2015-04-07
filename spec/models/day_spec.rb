require 'rails_helper'

RSpec.describe Day, :type => :model do

  describe ".num_pending" do
    it "returns the total number of days pending approval" do
      expect(Day.num_pending).to eq(0)
      pending = Day.create! :id => 1, :total_time => 60, :date => Date.today.prev_day,
                            :approved => false, :denied => false, :reason => "r"
       expect(Day.num_pending).to eq(1)
      logged = Day.create! :id => 2, :total_time => 60, :date => Date.today,
                           :approved => true, :denied => false, :reason => "r"
       expect(Day.num_pending).to eq(1)
    end
  end

  describe '#valid_total' do
    context 'Total time is less than 1 hour' do
      it 'Should raise error - total cant be less than 60 mins' do
        today = Date.today
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
        today = Date.today
        day = Day.new({:date => today,
                    :approved => true,
                    :denied => false,
                    :total_time => 1441,
                    :reason => "none"})
        assert !day.valid?
        expect(day.errors.full_messages[0]).to eq("Total can't be more than 24 hours")
      end
    end
  end

  describe '#valid_date' do
    before :each do
      #something
    end
    context 'Date is later than the 5th of the month and approved is false' do
      before :each do
        Date.stub(:today).and_return(Date.new(2015, 01, 07))
      end
      context 'date in future' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => Time.strptime("02/02/2015", "%m/%d/%Y"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 02/02/2015 is not within allowed range")
        end
      end
      context 'date too far in past' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => Time.strptime("12/31/2014", "%m/%d/%Y"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 12/31/2014 is not within allowed range")
        end
      end
      context 'date is today' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => Time.strptime("01/07/2015", "%m/%d/%Y"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 01/07/2015 is not within allowed range")
        end
      end
      context 'date in range' do
        it 'should be valid and have no errors' do
          day = Day.new({:date => Time.strptime("01/02/2015", "%m/%d/%Y"),
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
        Date.stub(:today).and_return(Date.new(2015, 01, 04))
      end
      context 'date in future' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => Time.strptime("02/02/2015", "%m/%d/%Y"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 02/02/2015 is not within allowed range")
        end
      end
      context 'date too far in past' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => Time.strptime("11/20/2014", "%m/%d/%Y"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 11/20/2014 is not within allowed range")
        end
      end
      context 'date is today' do
        it 'should not be valid and should give an error' do
          day = Day.new({:date => Time.strptime("01/04/2015", "%m/%d/%Y"),
                      :approved => false,
                      :denied => false,
                      :total_time => 60,
                      :reason => "Vacation"})
          assert !day.valid?
          expect(day.errors.full_messages[0]).to eq("Date 01/04/2015 is not within allowed range")
        end
      end
      context 'date in range' do
        it 'should be valid and have no errors' do
          day = Day.new({:date => Time.strptime("12/30/2014", "%m/%d/%Y"),
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
