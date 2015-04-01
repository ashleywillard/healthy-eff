class UsersController < ApplicationController
  before_filter :check_logged_in

  def profile
  	@now = DateTime.now
  	@currentMonth = @now.strftime('%m').to_i
    @currentYear = @now.strftime('%Y').to_i

    @previousMonth = @currentMonth - 1
    @previousYear = @currentYear
    if @currentMonth== 0
      @pseviousMonth = 12
      @previousYear -= 1
    end

    @curr_user_month = Month.where(:month => @currentMonth, 
    							                 :year => @currentYear,
    							                 :user_id => current_user.id).first
    
    @prev_user_month = Month.where(:month => @previousMonth, 
    							                 :year => @previousYear,
    							                 :user_id => current_user.id).first	
    
    @workouts = populate_workouts(@prev_user_month) + populate_workouts(@curr_user_month)

  end

  
  def populate_workouts(curr_month)
    workouts = []
    return [] if(curr_month == nil)  
    
    curr_month.days.each do |day|
      day.activities.each do |activity|
        workouts.push([activity.name, activity.duration, day.date])	
      end
    end
    return workouts
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
