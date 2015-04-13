require 'rails_helper'
require 'spec_helper'
include DateFormat

RSpec.describe Month, :type => :model do
  before :each do
    user = User.create!({:first_name => 'Will',
                    :last_name => 'Guo',
                    :email => '169.healthyeff@gmail.com',
                    :password => 'northsidepotato',
                    :password_confirmation => 'northsidepotato'})
    today = Date.today
    @month = get_month(today)
    @last_month = get_month(today.ago(1.month))
    @year = get_year(today)
    @user_id = user.id
    @month_model = Month.create!({:user_id => @user_id,
                   :month => @month,
                   :year => @year,
                   :printed_form => false,
                   :received_form => false,
                   :num_of_days => 1})
    Day.create({:date => format_date(today),
                      :reason => "",
                      :month_id => @month_model.id, 
                      :total_time => 60,
                      :approved => true,
                      :denied => false})
  end
  describe '#self.get_month_model' do
    context 'Month already exists' do
      it 'should successfuly return the correct month' do
        assert @month_model == Month.get_month_model(@user_id, @month, @year)
      end
    end
    context 'Month does not exist' do
      it 'should return nil' do
        assert nil == Month.get_month_model(@user_id, @last_month, @year)
      end
    end
  end
  describe '#self.get_or_create_month_model' do
    context 'Month already exists' do
      it 'should successfully get the correct month' do
        Month.should_not_receive(:create!)
        assert @month_model == Month.get_or_create_month_model(@user_id, @month, @year)
      end
    end
    context 'Month does not exist' do
      it 'should successfully create a new month' do
        mock = double('Month')
        Month.should_receive(:create!).and_return(mock)
        expect(Month.get_or_create_month_model(@user_id, @last_month, @year)).to eq(mock)
        #assert month != nil
      end
    end
  end
  describe '#self.get_inputted_dates' do
    context 'Month of start date and end date differ' do
      it 'not implemented'
    end
    context 'Month of start date and end date are same' do
      it 'not implemented'
    end
  end
  describe '#self.get_dates_list' do
    context 'Month does not exist' do
      it 'should return empty list'
    end
    context 'Month has no days' do
      it 'not implemented'
    end
    context 'Month exists and has days' do
      it 'should return list of days this month'
    end
  end
  describe '#self.get_users_earliest_month' do
    context 'User has no months' do
      it 'should return nil'
    end
    context 'User has months' do
      it 'should return earliest month model'
    end
  end
  describe '#self.get_earliest_months' do
    context 'No months exist' do
      it 'should return nil'
    end
    context 'Months exist' do
      it 'should return the ones that fall in the earliest month recorded'
    end
  end
  describe '#contains_date?' do
    context 'Month does not contain a specific date' do
      it 'should return false'
    end
    context 'Month does contain a specific date' do
      it 'should return true'
    end
  end
end
