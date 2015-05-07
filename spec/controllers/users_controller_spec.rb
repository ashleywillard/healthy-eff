require "rails_helper"

RSpec.describe UsersController do

  before :each do
    Constant.create! :curr_rate => 10
  end

  describe "Calendar method" do
    before :each do
      user = double('user')
      user.stub(:first_name).and_return('first')
      user.stub(:last_name).and_return('last')
      user.stub(:id).and_return(1)
      user.stub(:current_timezone).and_return("Pacific Time (US & Canada)")
      User.stub(:find).and_return(user)
      allow(user).to receive(:password_changed?).and_return(true)
      allow_message_expectations_on_nil
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
    it "Returns empty when user has not worked out ever" do
      Month.stub(:get_users_earliest_month)
      UsersController.any_instance.stub(:get_list_of_amt_per_month).and_return([])
      UsersController.any_instance.stub(:get_all_workouts).and_return([])

      get :calendar
      controller.instance_eval{@workouts}.should eql []
      response.should be_success
    end
    it "Returns all workout info for all previous months" do
      firstMonth = [['swimming', 80, '03-01-2015', "#3c763d", "#dff0d8", "#d6e9c6", "Status: Approved"]]
      secondMonth = [['running', 60, '04-01-2015', '#8a6d3b', '#fcf8e3', '#faebcc', "Status: Pending"],['climbing', 60, '04-02-2015', '#a94442', '#f2dede', '#ebccd1', "Status: Denied"]]
      Month.stub(:get_users_earliest_month)
      UsersController.any_instance.stub(:get_list_of_amt_per_month).and_return([])
      UsersController.any_instance.stub(:get_all_workouts).and_return(firstMonth + secondMonth)

      get :calendar
      controller.instance_eval{@workouts}.should eql firstMonth + secondMonth
      response.should be_success
    end
  end

  describe "Get All Workouts" do
    before :each do
      user = double('user')
      user.stub(:first_name).and_return('first')
      user.stub(:last_name).and_return('last')
      user.stub(:id).and_return(1)
      allow(user).to receive(:password_changed?).and_return(true)
      allow_message_expectations_on_nil
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
    it "should call Retrieve workouts for certain number of months" do
      start = Date.new(2015,03,01)
      finish = Date.new(2015,04,15)
      firstMonth = [['swimming', 80, '03-01-2015', "#3c763d", "#dff0d8", "#d6e9c6", "Status: Approved"]]
      secondMonth = [['running', 60, '04-01-2015', '#8a6d3b', '#fcf8e3', '#faebcc', "Status: Pending"],['climbing', 60, '04-02-2015', '#a94442', '#f2dede', '#ebccd1', "Status: Denied"]]
      UsersController.any_instance.stub(:retrieve_workouts).and_return(firstMonth, secondMonth)
      controller.get_all_workouts(start, finish).should eql firstMonth + secondMonth
    end
  end

  describe "Retrieve Workouts" do
    before :each do
      user = double('user')
      user.stub(:first_name).and_return('first')
      user.stub(:last_name).and_return('last')
      user.stub(:id).and_return(1)
      allow(user).to receive(:password_changed?).and_return(true)
      allow_message_expectations_on_nil
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
    it "retrieves workouts for given months" do
      activity1 = double('activity', :name => 'running', :duration => 60)
      activity2 = double('activity', :name => 'jogging', :duration => 60)
      activity3 = double('activity', :name => 'hiking', :duration => 80)
      month = double('Month', :month => 4, :year => 2015, :num_of_days => 2)

      days = [double('Day', :date => '04-01-2015', :approved => true, :denied => false),
              double('Day', :date => '04-02-2015', :approved => true, :denied => false)]

      activities1 = [activity1, activity2]
      activities2 = [activity3]

      Month.stub_chain(:where, :first).and_return(month)
      month.should_receive(:days).and_return(days)
      days[0].should_receive(:activities).and_return(activities1)
      days[1].should_receive(:activities).and_return(activities2)
      days[0].stub(:get_date_in_correct_timezone).and_return(days[0].date)
      days[1].stub(:get_date_in_correct_timezone).and_return(days[1].date)
      controller.retrieve_workouts(4, 2015).should eql [['running', 60, '04-01-2015', "#3c763d", "#dff0d8", "#d6e9c6", "Status: Approved"],
                                                        ['jogging', 60, '04-01-2015', "#3c763d", "#dff0d8", "#d6e9c6", "Status: Approved"],
                                                        ['hiking', 80, '04-02-2015', "#3c763d", "#dff0d8", "#d6e9c6", "Status: Approved"]]
    end
    it "returns empty list if month is non-existent" do
      Month.stub_chain(:where, :first).and_return(nil)
      controller.retrieve_workouts(4, 2015).should eql []
    end
    it "marks denied workouts as red" do
      denied_activity = double('Activity', :name => 'hiking', :duration => 80)
      month = double('Month', :month => 4, :year => 2015, :num_of_days => 1)
      days = [double('Day', :date => '04-01-2015', :approved => false, :denied => true)]
      activities = [denied_activity]

      Month.stub_chain(:where, :first).and_return(month)
      month.should_receive(:days).and_return(days)
      days[0].should_receive(:activities).and_return(activities)
      days[0].should_receive(:denied?).and_return(true)
      days[0].stub(:get_date_in_correct_timezone).and_return(days[0].date)
      controller.retrieve_workouts(4, 2015).should eql [['hiking', 80, '04-01-2015', '#a94442', '#f2dede', '#ebccd1', "Status: Denied"]]
    end
    it "marks pending workouts as yellow" do
      pending_activity = double('Activity', :name => 'jogging', :duration => 60)
      month = double('Month', :month => 4, :year => 2015, :num_of_days => 1)
      days = [double('Day', :date => '04-01-2015', :approved => false, :denied => false)]
      activities = [pending_activity]

      Month.stub_chain(:where, :first).and_return(month)
      month.should_receive(:days).and_return(days)
      days[0].should_receive(:activities).and_return(activities)
      days[0].should_receive(:denied?).and_return(false)
      days[0].stub(:get_date_in_correct_timezone).and_return(days[0].date)
      controller.retrieve_workouts(4, 2015).should eql [['jogging', 60, '04-01-2015', '#8a6d3b', '#fcf8e3', '#faebcc', "Status: Pending"]]
    end
    it "marks approved workouts as green" do
      approved_activity = double('activity', :name => 'running', :duration => 60)
      month = double('Month', :month => 4, :year => 2015, :num_of_days => 1)
      days = [double('Day', :date => '04-01-2015', :approved => true, :denied => false)]
      activities = [approved_activity]

      Month.stub_chain(:where, :first).and_return(month)
      month.should_receive(:days).and_return(days)
      days[0].should_receive(:activities).and_return(activities)
      days[0].stub(:get_date_in_correct_timezone).and_return(days[0].date)
      controller.retrieve_workouts(4, 2015).should eql [['running', 60, '04-01-2015', "#3c763d", "#dff0d8", "#d6e9c6", "Status: Approved"]]
    end
  end

  describe 'get money earned for this month' do
    before :each do
      user = double('user')
      user.stub(:first_name).and_return('first')
      user.stub(:last_name).and_return('last')
      user.stub(:id).and_return(1)
      allow(user).to receive(:password_changed?).and_return(true)
      allow_message_expectations_on_nil
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
    it 'computes amount of money earned from approved days this month' do
      start = Date.new(2015,03,01)
      finish = Date.new(2015,04,15)

      UsersController.any_instance.stub(:num_of_months_to_retrieve).and_return(2)
      Month.stub(:get_money_for_month).and_return('$10', '$20')

      controller.get_list_of_amt_per_month(start, finish).should eql ['$10', '$20']
    end
  end

end
