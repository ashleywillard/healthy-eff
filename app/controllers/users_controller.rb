class UsersController < ApplicationController
  before_filter :check_logged_in

  def profile
    
  end

  def manage
    if !current_user.admin?
      flash[:notice] = "Unauthorized access"
      redirect_to root_path
    end
    @users = User.find(:all, :conditions => ["id != ?", current_user.id])
  end

  def destroy
    if !current_user.admin?
      flash[:notice] = "Unauthorized access"
      redirect_to root_path
    end
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "User '#{@user.first_name}' '#{@user.last_name}' deleted."
    redirect_to manage_path
  end

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end

end
