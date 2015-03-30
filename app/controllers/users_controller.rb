class UsersController < ApplicationController

  def profile
  	@now = Time.now
  	@currentMonth = @now.month
  	@previousMonth = @currentMonth-1 == 0 ? 12 : @currentMonth-1 
    
  end

  def invite_user
    @user = User.invite!(:email => params[:user][:email], :name => params[:user][:name])
    render :json => @user
  end


end
