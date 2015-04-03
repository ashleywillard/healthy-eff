class UsersController < ApplicationController
  before_filter :check_logged_in

  def profile
    @name = 'No name'
    if current_user.first_name != nil && current_user.last_name != nil
      @name = current_user.first_name + ' ' + current_user.last_name
    end
    @date = Date.today 
    @earliestDate = @date.at_beginning_of_month.next_month

    @workouts = []
    numOfMonthsToRetrieve = 2
    (1..numOfMonthsToRetrieve).each do 
      @earliestDate = @earliestDate.at_beginning_of_month.prev_month
      @workouts += retrieveWorkouts(@earliestDate.month, @earliestDate.year)
    end
  end

  def retrieveWorkouts(month, year)
    curr_month = Month.where(:month => month, :year => year, :user_id => current_user.id).first
    workouts = []
    return [] if(curr_month == nil)  
    
    curr_month.days.each do |day|
      day.activities.each do |activity|
      	status = 'green'
      	if !day.approved
      		status = day.denied ? 'red' : 'yellow'
      	end
        workouts.push([activity.name, activity.duration, day.date, status])	
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
