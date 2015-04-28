class UsersController < ApplicationController

  before_filter :check_logged_in, :force_password_change

  def calendar
    if (params[:id] != nil && !current_user.admin)
      redirect_to calendar_path
    end
    @name = set_name
    @date = Date.today
    earliest_month = Month.get_users_earliest_month(extract_id_for_calendar)
    @earliest_date = (earliest_month == nil) ? @date : Date.new(earliest_month.year,earliest_month.month, 1)
    @workouts = get_all_workouts(@earliest_date, @date)
    @money = get_money_earned(@date.strftime("%m"), @date.strftime("%Y"))
  end

  def extract_id_for_calendar
    id = params[:id] != nil && User.find_by_id(params[:id]) != nil && current_user.admin ? params[:id] : current_user.id
    return id
  end

  def set_name
    name = 'No name'
    target_user = User.find(extract_id_for_calendar)
    if target_user.first_name != nil && target_user.last_name != nil
      name = target_user.first_name + ' ' + target_user.last_name
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
    id = extract_id_for_calendar
    curr_month = Month.get_month_model(id, month, year)
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
      workout += ['#3c763d', '#dff0d8', '#d6e9c6', "Status: Approved"]
    elsif day.denied?
      workout += ['#a94442', '#f2dede', '#ebccd1', "Status: Denied"]
    else
      workout += ['#8a6d3b', '#fcf8e3', '#faebcc', "Status: Pending"]
    end
    return workout
  end

  def get_money_earned(month, year)
    id = extract_id_for_calendar
    amt_per_day = 10
    approved_cnt = Month.get_approved_dates_list(id, month, year).length
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
