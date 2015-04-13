require "rails_helper"

RSpec.describe UsersController do

  describe "Profile method" do
    before :each do
      user = double('user')
      user.stub(:first_name).and_return('first')
      user.stub(:last_name).and_return('last')
      allow_message_expectations_on_nil
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
    it "Returns empty when user has not worked out for current or previous month" do
      UsersController.any_instance.stub(:retrieveWorkouts).and_return([])
      get :profile
      controller.instance_eval{@workouts}.should eql []
      response.should be_success
    end
    it "Returns all workout info for current or previous month" do
      firstMonth = [['swimming', 80, '03-01-2015', 'green']]
      secondMonth = [['running', 60, '04-01-2015', 'yellow'],['climbing', 60, '04-02-2015', 'red']]
      UsersController.any_instance.stub(:retrieveWorkouts).and_return(firstMonth, secondMonth)
      get :profile
      controller.instance_eval{@workouts}.should eql firstMonth + secondMonth
      response.should be_success
    end
  end

  describe "Retrieve Workouts" do
    before :each do
      user = double('user')
      user.stub(:first_name).and_return('first')
      user.stub(:last_name).and_return('last')
      user.stub(:id).and_return(1)
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
      controller.retrieveWorkouts(4, 2015).should eql [['running', 60, '04-01-2015', 'green'],
                                                        ['jogging', 60, '04-01-2015', 'green'],
                                                        ['hiking', 80, '04-02-2015', 'green']]
    end
    it "returns empty list if month is non-existent" do
      Month.stub_chain(:where, :first).and_return(nil)
      controller.retrieveWorkouts(4, 2015).should eql []
    end
    it "marks denied workouts as red" do
      denied_activity = double('Activity', :name => 'hiking', :duration => 80)
      month = double('Month', :month => 4, :year => 2015, :num_of_days => 1)
      days = [double('Day', :date => '04-01-2015', :approved => false, :denied => true)]
      activities = [denied_activity]

      Month.stub_chain(:where, :first).and_return(month)
      month.should_receive(:days).and_return(days)
      days[0].should_receive(:activities).and_return(activities)
      controller.retrieveWorkouts(4, 2015).should eql [['hiking', 80, '04-01-2015', 'red']]
    end
    it "marks pending workouts as yellow" do
      pending_activity = double('Activity', :name => 'jogging', :duration => 60)
      month = double('Month', :month => 4, :year => 2015, :num_of_days => 1)
      days = [double('Day', :date => '04-01-2015', :approved => false, :denied => false)]
      activities = [pending_activity]

      Month.stub_chain(:where, :first).and_return(month)
      month.should_receive(:days).and_return(days)
      days[0].should_receive(:activities).and_return(activities)
      controller.retrieveWorkouts(4, 2015).should eql [['jogging', 60, '04-01-2015', 'yellow']]
    end
    it "marks approved workouts as green" do
      approved_activity = double('activity', :name => 'running', :duration => 60)
      month = double('Month', :month => 4, :year => 2015, :num_of_days => 1)
      days = [double('Day', :date => '04-01-2015', :approved => true, :denied => false)]
      activities = [approved_activity]

      Month.stub_chain(:where, :first).and_return(month)
      month.should_receive(:days).and_return(days)
      days[0].should_receive(:activities).and_return(activities)
      controller.retrieveWorkouts(4, 2015).should eql [['running', 60, '04-01-2015', 'green']]
    end
  end

  describe 'non-admin' do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = User.create(:email=>'meow@meow.com', :password=>'?Meowmeowbeans169', :password_confirmation=>'?Meowmeowbeans169')
      sign_in @user
      UsersController.any_instance.should_receive(:current_user).at_least(1).and_return @user
      allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
    end
    it "should not be able to delete a user" do
      post :destroy, {:id => 1}
      expect(response).to redirect_to(root_path)
      flash[:notice].should eql('Unauthorized access')
    end
  end
end
