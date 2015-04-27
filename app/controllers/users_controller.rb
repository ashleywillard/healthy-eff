class UsersController < ApplicationController

  before_filter :check_logged_in, :force_password_change

  def calendar
    @name = set_name
    @date = Date.today
    earliest_month = Month.get_users_earliest_month(current_user.id)
    @earliest_date = (earliest_month == nil) ? @date : Date.new(earliest_month.year,earliest_month.month, 1)   
    @workouts = get_all_workouts(@earliest_date, @date)
    @money = get_money_earned(@date.strftime("%m"), @date.strftime("%Y"))
  end

  def set_name
    name = 'No name'
    if current_user.first_name != nil && current_user.last_name != nil
      name = current_user.first_name + ' ' + current_user.last_name
    end
    return name
  end

  def get_all_workouts(start, finish)
    workouts = [] 
    (1..num_of_months_to_retrieve(start, finish)).each do
      workouts += retrieve_workouts(finish.month, finish.year)
      finish = finish.at_beginning_of_month.prev_month
    end
    return workouts
  end

  def num_of_months_to_retrieve(start, finish)
    return 1 + (finish.year*12 + finish.month) - (start.year*12 + start.month)
  end

  def retrieve_workouts(month, year)
    curr_month = Month.get_month_model(current_user.id, month, year)
    return [] if(curr_month == nil)
    workouts = []
    curr_month.days.each do |day|
      day.activities.each do |activity|
        workouts.push(retrieve_workout(activity, day))
      end
    end
    return workouts
  end

  def retrieve_workout(activity, day)
    workout = [activity.name, activity.duration, day.date]
    if day.approved
      workout += ['#3c763d', '#dff0d8', '#d6e9c6']
    elsif day.denied?
      workout += ['#a94442', '#f2dede', '#ebccd1']
    else
      workout += ['#8a6d3b', '#fcf8e3', '#faebcc']
    end
    return workout
  end

  def get_money_earned(month, year)
    amt_per_day = 10
    approved_cnt = Month.get_approved_dates_list(current_user.id, month, year).length
    return "$" + (approved_cnt * amt_per_day).to_s
  end

  def check_admin
    if !current_user.admin?
      flash[:alert] = deny_access get_current_page
      redirect_to today_path
    end
  end

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end

end
