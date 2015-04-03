require "rails_helper"

RSpec.describe DaysController do

  describe "when logged in" do
    before :each do
      user = double('user')
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end

    it "displays the log activity page" do
      post :add_today
      expect(response).to redirect_to(today_path)
    end
  end

  describe "when not logged in" do
    before :each do
      request.env['warden'].stub(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    end

    it "redirects to login page" do
      post :add_today
      expect(response).to redirect_to(new_user_session_path)
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
      it 'should redirect to multiple_days_path' do
        DaysController.any_instance.stub(:check_logged_in)
        DaysController.any_instance.stub(:add).and_raise(Exception)
        post :add_days
        response.should redirect_to(multiple_days_path)
      end
    end
  end

  describe "adding today" do
    before :each do
      user = double(User)
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
      DaysController.any_instance.stub(:check_logged_in)
      DaysController.any_instance.stub(:check_simple_captcha).and_return(true)
    end
    context 'All inputs are present and valid' do
      it 'should successfully add today to database and redirect to profile page' do
        params = {:days => {:reason => "none"}, :day => {:date => "2015-04-02", :activities_attributes => {"1" =>{:name => "swimming", :duration => "90"}}}}
        post :add_today, params
        #Check the database also
        expect(flash[:notice]).to eq("swimming for 90 minutes has been recorded for 04/02/2015\n")
        response.should redirect_to(profile_path)
      end
    end
    context 'Duration field is empty for Activity' do
      it 'should redirect to multiple days path and display duration empty error' do
        params = {:days => {:reason => "none"}, :day => {:date => "2015-04-02", :activities_attributes => {"1" =>{:name => "", :duration => ""}}}}
        post :add_today, params
        expect(flash[:notice]).to eq("Duration can't be blank")
        response.should redirect_to(today_path)
      end
    end
    context 'Activity duration is invalid' do
      it 'should redirect to multiple days path and display duration invalid error' do
        params = {:days => {:reason => "none"}, :day => {:date => "2015-04-02", :activities_attributes => {"1" =>{:name => "", :duration => "-1"}}}}
        post :add_today, params
        expect(flash[:notice]).to eq("Duration can't be less than 0")
        response.should redirect_to(today_path)
      end
    end
  end

  describe "Adding multiple days" do
    before :each do
      DaysController.any_instance.stub(:check_logged_in)
      DaysController.any_instance.stub(:check_simple_captcha).and_return(true)
    end
    context 'all inputs are present and valid' do
      it 'should successfully add days to database and redirect to profile page' do
        params = {:days => {:reason => "Vacation"}, :user => {:days_attributes => 
                              {"1" => {:date => "04/01/2015", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        #Check the database also
        post :add_days, params
        expect(flash[:notice]).to eq("running for 60 minutes has been recorded for 04/01/2015\n")
        response.should redirect_to(profile_path)
      end
    end
    context 'Date argument is invalid' do
      it 'should redirect to multiple days path and flash invalid date error' do
        params = {:days => {:reason => "Vacation"}, :user => {:days_attributes => 
                              {"1" => {:date => "RAWR", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        post :add_days, params
        expect(flash[:notice]).to eq("Date is invalid")
        response.should redirect_to(multiple_days_path)
      end
    end
    context 'Reason field is empty for Day' do
      it 'should redirect to multiple days path and flash reason is empty error' do
        params = {:days => {:reason => ""}, :user => {:days_attributes => 
                              {"1" => {:date => "04/01/2015", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        post :add_days, params
        expect(flash[:notice]).to eq("Reason can't be blank")
        response.should redirect_to(multiple_days_path)
      end
    end
    context 'Date field is empty for Day' do
      it 'should redirect to multiple days path and flash date is empty error' do
        params = {:days => {:reason => "Vacation"}, :user => {:days_attributes => 
                              {"1" => {:date => "", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        post :add_days, params
        expect(flash[:notice]).to eq("Date is invalid")
        response.should redirect_to(multiple_days_path)
      end
    end
    context 'No days are added to params' do
      it 'should flash Fields are empty and redirect to multiple days path' do
        params = {:user => {}}
        post :add_days
        expect(flash[:notice]).to eq("Fields are empty")
        response.should redirect_to(multiple_days_path)
      end
    end
    context 'No activities are added to params for a single day' do
      it 'should flash Fields are empty and redirect to multiple days path' do
        params = {:user => {:days_attributes => {"1" => {:date => "04/01/2015"}}}}
        post :add_days
        expect(flash[:notice]).to eq("Fields are empty")
        response.should redirect_to(multiple_days_path)
      end
    end
    context 'Date field contains todays date' do
      it 'should redirect to multiple days path and flash invalid date error' do
        Date.stub!(:today).and_return(Date.new(2015, 04, 04))
        params = {:days => {:reason => "Vacation"}, :user => {:days_attributes => 
                              {"1" => {:date => "04/04/2015", :activities_attributes => {"2" => {:name => "running", :duration => "60"}}}}}}
        post :add_days, params
        expect(flash[:notice]).to eq("04/04/2015 is not within allowed range")
        response.should redirect_to(multiple_days_path)
      end
    end
  end

  describe "handles bad captcha" do
    it "add_today should fail because captcha is bad" do 
      DaysController.any_instance.stub(:check_logged_in)
      DaysController.any_instance.stub(:check_simple_captcha).and_return(false)
      post :add_today
      flash[:notice].should eql("Bro, your captcha was so wrong dude.")
      response.should redirect_to(today_path)
    end

    it "add_days should fail because captcha is bad" do 
      DaysController.any_instance.stub(:check_logged_in)
      DaysController.any_instance.stub(:check_simple_captcha).and_return(false)
      post :add_days
      flash[:notice].should eql("Bro, your captcha was so wrong dude.")
      response.should redirect_to(multiple_days_path)
    end
  end

end
