class ActivitiesController < ApplicationController
  
  before_filter :check_logged_in

  def today
    @date = DateTime.now
    @day = Day.new({:date => @date,
                      :reason => "", 
                      :approved => true,
                      :user_id => current_user})
  end

  def multiple_days
    @user = User.find(current_user)
  end

  def check_simple_captcha
    if Rails.env.production?
      return simple_captcha_valid?
    else
      return true
    end
  end

  def bad_captcha
    flash[:notice] = "Bro, your captcha was so wrong dude."
  end

  def empty_fields_notice
    flash[:notice] = "Fields are empty"
  end

  def add_activity
    unless check_simple_captcha
      bad_captcha
      redirect_to today_path
    else
      check_today()
    end
  end

  def check_today
    unless params[:day] == nil || params[:day][:activities_attributes] == nil
      if add_single_day(params[:day][:activities_attributes], true, params[:day][:date])
        redirect_to profile_path
      else
        redirect_to today_path
      end
    else
      empty_fields_notice()
      redirect_to today_path
    end
  end

  def add_single_day(activity_list, approved, date)
    @day = Day.new({:date => date,
                    :approved => approved,
                    :total_time => 0,
                    :user_id => current_user,
                    :reason => params[:days][:reason]})
    activities = []
    activities_valid = true

    activity_list.each do |id, activity|
      new_activity = create_activity(activity, @day)
      activities += [new_activity]
      unless new_activity.valid? 
        flash[:notice] = flash[:notice] || new_activity.errors.full_messages[0]
        activities_valid = false
        break
      end
    end

    unless activities_valid && @day.valid?
      flash[:notice] = flash[:notice] || @day.errors.full_messages[0]
      return false # unsuccessful
    else
      save_single_day(activities, @day)
      return true # successful
    end
  end

  def create_activity(activity, day)
    name = activity[:name].lstrip
    duration = activity[:duration]
    day.total_time += duration.to_i
    if name == "" then name = "A Healthy Activity" end
    @activity = Activity.new({:name => name,
                              :duration => duration,
                              :day_id => day.id})
  end

  def save_single_day(activities, day)
    notice = ""
    activities.each do |activity|
      activity.save
      day.save
      notice += "#{activity.name} for #{activity.duration} minutes has been recorded for #{day.date.strftime("%m/%d/%Y")}\n"
    end
    flash[:notice] = notice
  end

  def add_days
    unless check_simple_captcha
      bad_captcha
      redirect_to multiple_days_path
    else
      unless params[:user] == nil || params[:user][:days_attributes] == nil
        check_multiple_days()
      else
        empty_fields_notice()
        redirect_to multiple_days_path
      end
    end
  end

  def check_multiple_days
    today = DateTime.now.strftime("%m/%d/%Y")
    success = true
    params[:user][:days_attributes].each do |id, day|
      unless day[:activities_attributes] == nil
        success = check_day(day, today)
      else
        success = false
        empty_fields_notice()
        redirect_to multiple_days_path
        break
      end
    end
    if success then redirect_to profile_path end
  end

  def check_day(day, todays_date)
    date = ""
    begin
      date = Time.parse(day[:date]).strftime("%m/%d/%Y")
    rescue Exception => e
      flash[:notice] = "Invalid Date"
      redirect_to multiple_days_path
      return false #unsuccessful
    end
    unless add_single_day(day[:activities_attributes], date == todays_date, date)
      redirect_to multiple_days_path
      return false #unsuccessful
    end
    return true #successful
  end

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
