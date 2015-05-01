class UsersController < ApplicationController
  include DateFormat
  before_filter :check_logged_in, :force_password_change

  def calendar
    if (params[:id] != nil && !current_user.admin)
      redirect_to calendar_path
    end
    @name = set_name
    @date = get_today
    earliest_month = Month.get_users_earliest_month(extract_id_for_calendar)
    @earliest_date = (earliest_month == nil) ? @date : Date.new(earliest_month.year,earliest_month.month, 1)
    @workouts = get_all_workouts(@earliest_date, @date)
    @amt_list = get_list_of_amt_per_month(@earliest_date, @date)

    @no_js_curr_workouts = get_all_workouts(@date, @date)
    @no_js_prev_workouts = get_all_workouts(@date.at_beginning_of_month.prev_month, @date.at_beginning_of_month.prev_month)
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

  def get_list_of_amt_per_month(start, finish)
    amt_list = []
    (1..num_of_months_to_retrieve(start, finish)).each do
      amt_list.push(Month.get_money_for_month(extract_id_for_calendar, finish.month, finish.year))
      finish = finish.at_beginning_of_month.prev_month
    end
    return amt_list
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

end
