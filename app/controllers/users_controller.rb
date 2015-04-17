class UsersController < ApplicationController

  before_filter :check_logged_in, :force_password_change

  def profile
    @name = 'No name'
    if current_user.first_name != nil && current_user.last_name != nil
      @name = current_user.first_name + ' ' + current_user.last_name
    end
    @date = Date.today
    earliest_month = Month.get_users_earliest_month(current_user.id)
    @earliest_date = Date.new(earliest_month.year,earliest_month.month, 1)
    
    @workouts = []
    numOfMonthsToRetrieve = 1+(@date.year*12+@date.month)-(@earliest_date.year*12+@earliest_date.month) 
    temp = @date
    (1..numOfMonthsToRetrieve).each do
      @workouts += retrieveWorkouts(temp.month, temp.year)
      temp = temp.at_beginning_of_month.prev_month
    end
    
    @money = getMoneyEarned(@date.strftime("%m"), @date.strftime("%Y"))
  end

  def getAllWorkouts(start, finish)
    
    
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

  def getMoneyEarned(month, year)
    amt_per_day = 10
    approved_cnt = Month.get_approved_dates_list(current_user.id, month, year).length
    return "$" + (approved_cnt * amt_per_day).to_s
  end

  def manage
    if !current_user.admin?
      flash[:notice] = "Unauthorized access"
      redirect_to today_path
    end
    @users = User.find(:all, :conditions => ["id != ?", current_user.id])
  end

  def destroy
    if !current_user.admin?
      flash[:notice] = "Unauthorized access"
      redirect_to root_path
    else
      @user = User.find(params[:id])
      @user.destroy
      flash[:notice] = "User '#{@user.first_name}' '#{@user.last_name}' deleted."
      redirect_to manage_path
    end

  end

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end

end
