require 'rails_helper'

RSpec.describe InvitationsController, :type => :controller do

	describe "deleting a user when not an admin" do
    before :each do
      @user = User.create(:email => "email", :first_name => "Bob")
      @user.admin = false
      @user.save
      allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
      allow(controller).to receive(:current_user).and_return(@user)
    end

		it "redirects to the home page" do
      sign_in(@user)
			delete :destroy, {:id => 1}
      expect(response).to redirect_to(today_path)
		end
	end

end
