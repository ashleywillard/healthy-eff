require "rails_helper"

RSpec.describe ActivitiesController do

  describe "when logged in" do
    before :each do
      user = double('user')
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
    end

    it "displays the log activity page" do
      post :add_activity
      expect(response).to redirect_to(today_path)
    end
  end

  describe "when not logged in" do
    before :each do
      request.env['warden'].stub(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    end

    it "redirects to login page" do
      post :add_activity
      expect(response).to redirect_to(new_user_session_path)
    end
  end

end
