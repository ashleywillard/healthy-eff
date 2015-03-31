class UsersController < ApplicationController

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
    flash[:notice] = "User '#{@user.name}' deleted."
    redirect_to manage_path
  end

end
