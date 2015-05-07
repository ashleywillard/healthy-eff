class Admin::ManageController < Admin::AdminController

  def index
    @users = User.where("id != ?", current_user.id)
    if not params[:sort].nil? and ActiveRecord::Base.connection.column_exists?(:users, params[:sort])
      @users = @users.order(params[:sort])
      session[:sort] = params[:sort]
    end
    @constant = Constant.get_constants
  end

  def update_constants
    rate = params[:constant][:curr_rate].to_i
    unless rate <= 0 || rate == Constant.get_work_rate
      Constant.set_work_rate(rate)
      Month.update_month_rates(current_user.current_timezone, rate)
      flash[:notice] = UPDATE_SUCCESSFUL
    end
    redirect_to manage_path
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = user_deleted(@user.first_name, @user.last_name)
    redirect_to manage_path
  end

  def update
    @user = User.find(params[:id])
    user_hash = params[:user]
    @user.first_name = user_hash[:first_name]
    @user.last_name = user_hash[:last_name]
    @user.email = user_hash[:email]
    if @user.save!
      flash[:notice] = "User settings successfully changed"
      redirect_to manage_path
    end
  end

  def make_admin
    @user = User.find(params[:id])
    @user.admin = true
    if @user.save!
      flash[:notice] = "Successfully made #{@user.first_name} an admin"
      redirect_to manage_path
    end
  end

  def edit
    @user = User.find(params[:id])
  end

end
