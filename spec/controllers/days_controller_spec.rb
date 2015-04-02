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

  describe "adding today" do
    context 'All inputs are present and valid' do
      it 'should successfully add today to database and redirect to profile page' #do
        #add stuff here
        #post :add_today
        #response.should redirect_to(profile_path)
      #end
    end
    context 'Name field is empty for Activity' do
      it 'should redirect to multiple days path and display name empty error' #do
        #add stuff here -- note it is in add method -- 
        #post :add_days
        #response.should redirect_to(multiple_days_path)
      #end
    end
    context 'Duration field is empty for Activity' do
      it 'should redirect to multiple days path and display duration empty error' #do
        #add stuff here -- note it is in add method -- 
        #post :add_days
        #response.should redirect_to(multiple_days_path)
      #end
    end
    context 'Activity duration is invalid' do
      it 'should redirect to multiple days path and display duration invalid error' #do
        #add stuff here
        #post :add_days
        #response.should redirect_to(multiple_days_path)
      #end
    end
  end

  describe "Adding multiple days" do
    context 'all inputs are present and valid' do
      it 'should successfully add days to database and redirect to profile page' #do
        #add stuff here for successfully adding days
        #post :add_days
        #response.should redirect_to(profile_path)
      #end
    end
    context 'Date argument is invalid' do
      it 'should redirect to multiple days path and flash invalid date error' #do
        #add stuff here
        #post :add_days
        #response.should redirect_to(multiple_days_path)
        #check flash for error
      #end
    end
    context 'Reason field is empty for Day' do
      it '' #do
        #add stuff here -- note it is in create_multiple_days
        #post :add_days
        #response.should redirect_to(multiple_days_path)
      #end
    end
    context 'Date field is empty for Day' do
      it '' #do
        #add stuff here -- note it is in create_multiple_days
        #post :add_days
        #response.should redirect_to(multiple_days_path)
      #end
    end
    context 'Date field contains todays date' do
      it 'should redirect to multiple days path and flash invalid date error' #do
        #add stuff here
        #post :add_days
        #response.should redirect_to(multiple_days_path)
      #end
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
