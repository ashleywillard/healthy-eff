require "rails_helper"
require File.expand_path("../../../users_helper", __FILE__)

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe Admin::ManageController do

  before :each do
    @user = mock_logged_in_admin()
    allow(controller).to receive(:current_user).and_return(@user)
    Constant.create! :curr_rate => 10
  end

  describe 'admin/manage#index' do
    context "when sorting params are invalid" do
      it "does not throw errors" do
        expect{ get :index, :sort => "bogus" }.to_not raise_error
      end
      it "does not update the session hash" do
        get :index, :sort => "bogus"
        expect(session[:sort]).to eq(nil)
      end
    end
  end

  describe 'admin/manage#delete' do
    context 'when non-admin' do
      before :each do
        allow(@user).to receive(:admin).and_return(false)
        User.create(:email=>'meow@meow.com', :password=>'?Meowmeowbeans169', :password_confirmation=>'?Meowmeowbeans169')
      end
      it "should not be able to delete a user" do
        extend ErrorMessages
        post :destroy, {:id => 2}
        expect(response).to redirect_to(today_path)
        flash[:alert].should eql(deny_access(""))
      end
    end
  end

end
