require 'rails_helper'
require 'spec_helper'

RSpec.describe InvitationsController, :type => :controller do

  describe 'non-admin' do
    it 'should not be able to send invitations' do
      user = mock('User')
      user.admin = false
      user.stub!(:password)
      user.stub!(:email)
      user.save!
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
      post :user_invitation
      expect(response).to redirect_to(root_path)
      flash[:notice].should eql('You are not authorized to send invites!')
    end
  end
end
