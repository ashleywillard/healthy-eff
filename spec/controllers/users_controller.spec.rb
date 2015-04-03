require 'spec_helper'

RSpec.describe UsersController do

  describe 'non-admin' do
  	before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = User.new(:email=>'meow@meow.com', :password=>'meowmeowbeans', :password_confirmation=>'meowmeowbeans')
      sign_in @user
      InvitationsController.any_instance.should_receive(:current_user).at_least(1).and_return @user
      allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
  	end
  	it "should not be able to delete a user" do
	  post :destroy, {:id => 1}
      expect(response).to redirect_to(root_path)
      flash[:notice].should eql('Unauthorized access')
	end
  end
end