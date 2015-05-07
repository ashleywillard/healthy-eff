require 'rails_helper'
require 'spec_helper'
include DateFormat

RSpec.describe Month, :type => :model do

  before :each do
    Timecop.freeze(Date.parse("10-4-2015"))
    Constant.create! :curr_rate => 10
    user = User.create!({:first_name => 'Will',
                    :last_name => 'Guo',
                    :email => '169.healthyeff@gmail.com',
                    :password => '?Northsidepotato169',
                    :password_confirmation => '?Northsidepotato169'})
    @user_id = user.id
    @today = get_today
    @month = get_month(@today)
    @last_month = get_month(@today.ago(1.month))
    @year = get_year(@today)
  end

  after :each do
    Timecop.return
  end

  describe '#self.get_month_model' do
    before :each do
      @month_model = Month.create_month_model(@user_id, @month, @year)
    end
    context 'Month already exists' do
      it 'should successfuly return the correct month' do
        expect(Month.get_month_model(@user_id, @month, @year)).to eq(@month_model)
      end
    end
    context 'Month does not exist' do
      it 'should return nil' do
        expect(Month.get_month_model(@user_id, @last_month, @year)).to eq(nil)
      end
    end
  end

  describe '#self.get_or_create_month_model' do
    before :each do
      @month_model = Month.create_month_model(@user_id, @month, @year)
    end
    context 'Month already exists' do
      it 'should successfully get the correct month' do
        Month.should_not_receive(:create!)
        expect(Month.get_or_create_month_model(@user_id, @month, @year)).to eq(@month_model)
      end
    end
    context 'Month does not exist' do
      it 'should successfully create a new month' do
        mock = double('Month')
        Month.should_receive(:create!).and_return(mock)
        expect(Month.get_or_create_month_model(@user_id, @last_month, @year)).to eq(mock)
      end
    end
  end

  describe '#self.get_inputted_dates' do
    before :each do
      @end_date = get_date("04/15/2015")
      @month1 = Month.create_month_model(@user_id, 4, 2015)
      @month1.num_of_days = 1
      @month1.save!
      @day1 = Day.create!({:date => @end_date,
                        :reason => "none",
                        :month_id => @month1.id,
                        :total_time => 60,
                        :approved => true,
                        :denied => false})
    end
    context 'Month of start date and end date differ' do
      it 'not implemented' do
        start_date = get_date("03/01/2015")
        month2 = Month.create_month_model(@user_id, 3, 2015)
        month2.num_of_days = 1
        month2.save!
        day2 = Day.create!({:date => start_date,
                        :reason => "none",
                        :month_id => month2.id,
                        :total_time => 60,
                        :approved => true,
                        :denied => false})
        expect(Month.get_inputted_dates(@user_id, start_date, @end_date)).to eq(["04/15/2015", "03/01/2015"].join(","))
      end
    end
    context 'Month of start date and end date are same' do
      it 'not implemented'do
        start_date = get_date("04/01/2015")
        expect(Month.get_inputted_dates(@user_id, start_date, @end_date)).to eq(["04/15/2015"].join(","))
      end
    end
  end

  describe '#self.get_dates_list' do
    before :each do
      @month_model = Month.create_month_model(@user_id, @month, @year)
      @month_model.num_of_days = 1
      @month_model.save!
    end
    context 'Month does not exist' do
      it 'should return empty list' do
        expect(Month.get_dates_list(@user_id, @last_month, @year)).to eq([])
      end
    end
    context 'Month has no days' do
      it 'should return empty list' do
        expect(Month.get_dates_list(@user_id, @month, @year)).to eq([])
      end
    end
    context 'Month exists and has days' do
      it 'should return list of days this month' do
        @day = Day.create!({:date => @today,
                        :reason => "none",
                        :month_id => @month_model.id,
                        :total_time => 60,
                        :approved => true,
                        :denied => false})
        expect(Month.get_dates_list(@user_id, @month, @year)).to eq([format_date(@today)])
      end
    end
  end

  describe '#self.get_approved_dates_list' do
    before :each do
      @month_model = Month.create_month_model(@user_id, @month, @year)
      @month_model.num_of_days = 1
      @month_model.save!
    end
    context 'Month does not exist' do
      it 'should return empty list' do
        expect(Month.get_approved_dates_list(@user_id, @last_month, @year)).to eq([])
      end
    end
    context 'Month has no days' do
      it 'should return empty list' do
        expect(Month.get_approved_dates_list(@user_id, @month, @year)).to eq([])
      end
    end
    it 'should return list of approved days this month' do
      @day=Day.create!({:date => @today,
                  :reason => "none",
                  :month_id => @month_model.id,
                  :total_time => 60,
                  :approved => true,
                  :denied => false})
      expect(Month.get_approved_dates_list(@user_id, @month, @year)).to eq([format_date(@today)])
    end
    it 'should not return non-approved days' do
      @today=Day.create!({:date => @today.at_beginning_of_month,
                  :reason => "none",
                  :month_id => @month_model.id,
                  :total_time => 60,
                  :approved => false,
                  :denied => false})
      expect(Month.get_approved_dates_list(@user_id, @month, @year)).to eq([])
    end
  end

  describe '#self.get_users_earliest_month' do
    before :each do
      @month1 = Month.create_month_model(@user_id, @month, @year)
      @month2 = Month.create_month_model(@user_id, @month, 2014)
    end
    context 'User has no months' do
      it 'should return nil' do
        expect(Month.get_users_earliest_month(@user_id + 1)).to eq(nil)
      end
    end
    context 'User has months' do
      it 'should return earliest month model' do
        expect(Month.get_users_earliest_month(@user_id)).to eq(@month2)
      end
    end
  end

  describe '#self.get_earliest_months' do
    context 'No months exist' do
      it 'should return nil' do
        expect(Month.get_earliest_months).to eq(nil)
      end
    end
    context 'Months exist' do
      it 'should return the ones that fall in the earliest month recorded' do
        month1 = Month.create_month_model(@user_id, @month, @year)
        month2 = Month.create_month_model(@user_id, @month, 2014)
        month3 = Month.create_month_model(@user_id + 1, @month, @year)
        month4 = Month.create_month_model(@user_id + 1, @month, 2014)
        expect(Month.get_earliest_months).to eq([month2, month4])
      end
    end
  end

  describe '#contains_date?' do
    before :each do
      @month_model = Month.create_month_model(@user_id, @month, @year)
      @month_model.num_of_days = 1
      @month_model.save!
      @day = Day.create!({:date => @today,
                        :reason => "none",
                        :month_id => @month_model.id,
                        :total_time => 60,
                        :approved => true,
                        :denied => false})
    end
    context 'Month does not contain a specific date' do
      it 'should return false' do
        assert @month_model.contains_date?(@today.prev_day) == false
      end
    end
    context 'Month does contain a specific date' do
      it 'should return true' do
        assert @month_model.contains_date?(@day.date)
      end
    end
  end
end
