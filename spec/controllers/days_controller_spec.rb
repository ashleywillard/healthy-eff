require "rails_helper"

RSpec.describe DaysController do

  let(:dummy_class) { Class.new { extend ErrorMessages } }

  before :each do
    Constant.create! :curr_rate => 10
    @user = double(User)
    allow(@user).to receive(:password_changed?).and_return(true)
    allow(@user).to receive(:id).and_return(1)
    allow_message_expectations_on_nil # suppress warnings on devise warden
    allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
    allow(controller).to receive(:current_user).and_return(@user)
  end

  describe "when logged in" do
    it "displays the log activity page" do
      post :add_today
      expect(response).to redirect_to(today_path)
    end
  end

  describe "when not logged in" do
    before :each do
      allow_message_expectations_on_nil
      request.env['warden'].stub(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    end

    it "redirects to login page" do
      post :add_today
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "password_changed? filter" do
    context "when signing in for the first time" do
      it "prompts the user to change his/her password" do
        allow(@user).to receive(:password_changed?).and_return(false)
        get :today
        expect(response).to redirect_to(edit_user_registration_path)
      end
    end
    context "when signing in having already changed password" do
      it "allows access" do
        get :today
        expect(response).to redirect_to(today_path)
      end
    end
  end

  describe "#add_today" do
    context "errors are present" do
      it 'should redirect to today_path' do
        DaysController.any_instance.stub(:check_logged_in)
        DaysController.any_instance.stub(:add).and_raise(Exception)
        post :add_today
        response.should redirect_to(today_path)
      end
    end
  end

  describe "#add_days" do
    context "errors are present" do
      it 'should redirect to past_days_path' do
        DaysController.any_instance.stub(:check_logged_in)
        DaysController.any_instance.stub(:add).and_raise(Exception)
        post :add_days
        response.should redirect_to(past_days_path)
      end
    end
  end

  describe "adding today" do
    before :each do
      @user = User.create!({:first_name => 'Will',
                    :last_name => 'Guo',
                    :email => '169.healthyeff@gmail.com',
                    :password => 'NewBaconings2day.',
                    :password_confirmation => 'NewBaconings2day.'})
      DaysController.any_instance.stub(:current_user).and_return(@user)
      DaysController.any_instance.stub(:check_logged_in)
      DaysController.any_instance.stub(:check_simple_captcha).and_return(true)
    end
    context 'All inputs are present and valid' do
      it 'should successfully add today to database and redirect to calendar page' do
        allow(@user).to receive(:password_changed?).and_return(true)
        DaysController.any_instance.stub(:current_user).and_return(@user)
        today = Date.today
        params = {:days => {:reason => "none"}, :day => {:date => "#{today}", :activities_attributes => {"1" =>{:name => "swimming", :duration => "90"}}}}
        post :add_today, params
        #Check the database also
        expect(flash[:notice]).to eq(dummy_class.activity_recorded("swimming", "90", "#{today.strftime("%m/%d/%Y")}"))
        response.should redirect_to(calendar_path)
      end
    end
    context 'Today was already input' do
      it 'should redirect to today path and display day already inputted error' do
        allow(@user).to receive(:password_changed?).and_return(true)
        DaysController.any_instance.stub(:current_user).and_return(@user)
        today = Date.today

        params = {:days => {:reason => "none"}, :day => {:date => "#{today}", :activities_attributes => {"1" =>{:name => "swimming", :duration => "90"}}}}
        post :add_today, params

        #try query again
        post :add_today, params
        #Check the database also
        expect(flash[:alert]).to eq(dummy_class.repeat_date("#{today.strftime("%m/%d/%Y")}"))
        response.should redirect_to(today_path)
      end
    end
    context 'Duration field is empty for Activity' do
      it 'should redirect to today path and display duration empty error' do
        allow(@user).to receive(:password_changed?).and_return(true)
        today = Date.today
        params = {:days => {:reason => "none"}, :day => {:date => "#{today}", :activities_attributes => {"1" =>{:name => "", :duration => ""}}}}
        post :add_today, params
        expect(flash[:alert]).to eq("Duration can't be blank")
        response.should redirect_to(today_path)
      end
    end
    context 'Activity duration is invalid' do
      it 'should redirect to today path and display duration invalid error' do
        allow(@user).to receive(:password_changed?).and_return(true)
        today = Date.today
        params = {:days => {:reason => "none"}, :day => {:date => "#{today}", :activities_attributes => {"1" =>{:name => "", :duration => "-1"}}}}
        post :add_today, params
        expect(flash[:alert]).to eq("Duration can't be less than 0")
        response.should redirect_to(today_path)
      end
    end
  end

  describe "Adding past days" do
    before :each do
      @user = User.create!({:first_name => 'Will',
                    :last_name => 'Guo',
                    :email => '169.healthyeff@gmail.com',
                    :password => 'Sushi5evar!',
                    :password_confirmation => 'Sushi5evar!'})
      allow(@user).to receive(:password_changed?).and_return(true)
      DaysController.any_instance.stub(:current_user).and_return(@user)
      DaysController.any_instance.stub(:check_logged_in)
      DaysController.any_instance.stub(:check_simple_captcha).and_return(true)
    end
    context 'Inputs are present and valid for multiple days and activities' do
      it 'should successfully add days to database and redirect to calendar page' do
        date1 = Date.today.prev_day.strftime("%m/%d/%Y")
        date2 = Date.today.prev_day.prev_day.strftime("%m/%d/%Y")
        params = {:days => {:reason => "Vacation"}, :month => {:days_attributes =>
                              {"1" => {:date => "#{date1}", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}},
                              "3" => {:date => "#{date2}", :activities_attributes => {"4" => {:name => "running", :duration => "20"}, "5" => {:name => "swimming", :duration => "40"}}}}}}
        #Check the database also
        post :add_days, params
        expect(flash[:notice]).to eq(dummy_class.activity_recorded("running", "60", "#{date1}") + dummy_class.activity_recorded("running", "20", "#{date2}") + dummy_class.activity_recorded("swimming", "40", "#{date2}"))
        response.should redirect_to(calendar_path)
      end
    end
    context 'Inputs are present and valid for single day and activity' do
      it 'should successfully add days to database and redirect to calendar page' do
        date = Date.today.prev_day.strftime("%m/%d/%Y")
        params = {:days => {:reason => "Vacation"}, :month => {:days_attributes =>
                              {"1" => {:date => "#{date}", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        #Check the database also
        post :add_days, params
        expect(flash[:notice]).to eq(dummy_class.activity_recorded("running", "60", "#{date}"))
        response.should redirect_to(calendar_path)
      end
    end
    context 'day was already input' do
      it 'should redirect to past days path and flash already inputted error' do
        date = Date.today.prev_day.strftime("%m/%d/%Y")
        params = {:days => {:reason => "Vacation"}, :month => {:days_attributes =>
                              {"1" => {:date => "#{date}", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        #Check the database also
        post :add_days, params

        #try again
        post :add_days, params
        expect(flash[:alert]).to eq(dummy_class.repeat_date("#{date}"))
        response.should redirect_to(past_days_path)
      end
    end
    context 'Date argument is invalid' do
      it 'should redirect to past days path and flash invalid date error' do
        params = {:days => {:reason => "Vacation"}, :month => {:days_attributes =>
                              {"1" => {:date => "RAWR", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        post :add_days, params
        expect(flash[:alert]).to eq(dummy_class.invalid_date)
        response.should redirect_to(past_days_path)
      end
    end
    context 'Reason field is empty for Day' do
      it 'should redirect to past days path and flash reason is empty error' do
        date = Date.today.prev_day.strftime("%m/%d/%Y")
        params = {:days => {:reason => ""}, :month => {:days_attributes =>
                              {"1" => {:date => "#{date}", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        post :add_days, params
        expect(flash[:alert]).to eq("Reason can't be blank")
        response.should redirect_to(past_days_path)
      end
    end
    context 'Date field is empty for Day' do
      it 'should redirect to past days path and flash date is empty error' do
        params = {:days => {:reason => "Vacation"}, :month => {:days_attributes =>
                              {"1" => {:date => "", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        post :add_days, params
        expect(flash[:alert]).to eq(dummy_class.invalid_date)
        response.should redirect_to(past_days_path)
      end
    end
    context 'No days are added to params' do
      it 'should flash Fields are empty and redirect to past days path' do
        params = {:month => {}}
        post :add_days
        expect(flash[:alert]).to eq(dummy_class.empty_fields)
        response.should redirect_to(past_days_path)
      end
    end
    context 'No activities are added to params for a single day' do
      it 'should flash Fields are empty and redirect to past days path' do
        date = Date.today.prev_day.strftime("%m/%d/%Y")
        params = {:month => {:days_attributes => {"1" => {:date => "#{date}"}}}}
        post :add_days
        expect(flash[:alert]).to eq(dummy_class.empty_fields)
        response.should redirect_to(past_days_path)
      end
    end
    context 'Date field contains todays date' do
      it 'should redirect to past days path and flash invalid date error' do
        date = Date.today.strftime("%m/%d/%Y")
        params = {:days => {:reason => "Vacation"}, :month => {:days_attributes =>
                              {"1" => {:date => "#{date}", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        post :add_days, params
        expect(flash[:alert]).to eq("Date #{date} is not within allowed range. Note: You only have until the 5th of the month to input days for the previous month.")
        response.should redirect_to(past_days_path)
      end
    end
  end

  describe "handles bad captcha" do
    it "add_today should fail because captcha is bad" do
      DaysController.any_instance.stub(:check_logged_in)
      DaysController.any_instance.stub(:check_simple_captcha).and_return(false)
      post :add_today
      flash[:alert].should eql(dummy_class.bad_captcha)
      response.should redirect_to(today_path)
    end

    it "add_days should fail because captcha is bad" do
      DaysController.any_instance.stub(:check_logged_in)
      DaysController.any_instance.stub(:check_simple_captcha).and_return(false)
      post :add_days
      flash[:alert].should eql(dummy_class.bad_captcha)
      response.should redirect_to(past_days_path)
    end
  end

end
