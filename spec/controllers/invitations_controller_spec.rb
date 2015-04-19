require 'rails_helper'
require 'spec_helper'

RSpec.describe InvitationsController, :type => :controller do

  describe 'non-admin' do
    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = User.new(:email=>'meow@meow.com', :password=>'?Meowmeowbeans169', :password_confirmation=>'?Meowmeowbeans169')
      sign_in @user
      InvitationsController.any_instance.should_receive(:current_user).at_least(1).and_return @user
      allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
    end
    it 'should not be able to send invitations' do
      extend ErrorMessages
      post :new
      expect(response).to redirect_to(root_path)
      flash[:alert].should eql(invite_refused)
    end
  end
end
